type 'a regexp =
    | Vide | Epsilon | L of 'a
    | Union of 'a regexp * 'a regexp
    | Concat of 'a regexp * 'a regexp
    | Etoile of 'a regexp

(* O(n+m) avec n et m la taille des listes *)
let fusion l1 l2 = 
    let rec aux l1 l2 acc = match l1, l2 with
        | [], _ -> acc@l2
        | _, [] -> acc@l1
        | p1::q1, p2::q2 -> begin
            if p1 < p2 then aux q1 l2 (p1::acc)
            else if p1 > p2 then aux l1 q2 (p2::acc)
            else aux q1 q2 (p1::acc)
        end
    in aux l1 l2 []

(*O(n) avec n la taille de e*)
let rec est_vide e = match e with
    | Vide -> true
    | Epsilon | L(_) -> false
    | Union(e1,e2) -> est_vide e1 && est_vide e2
    | Concat(e1,e2) -> est_vide e1 || est_vide e2
    | Etoile(e1) -> est_vide e1

(*O(n) avec n la taille de e*)
let rec a_epsilon e = match e with 
    | Epsilon | Etoile(_) -> true
    | Vide | L(_) -> false
    | Concat(e1,e2) -> a_epsilon e1 && a_epsilon e2
    | Union(e1,e2) -> a_epsilon e1 || a_epsilon e2

let rec p e =  match e with
    | Vide | Epsilon -> []
    | L (a) -> [a]
    | Concat(e1,e2) -> if est_vide e then [] else fusion (p e1) (if a_epsilon e1 then p e2 else [])
    | Union(e1,e2) -> fusion (p e1) (p e2)
    | Etoile e1 -> p e1

let rec s e = match e with 
    | Vide | Epsilon -> []
    | L (a) -> [a]
    | Concat(e1,e2) -> if est_vide e then [] else fusion (s e2) (if a_epsilon e2 then s e1 else [])
    | Union(e1,e2) -> fusion (s e1) (s e2)
    | Etoile e1 -> s e1

let produit l1 l2 =
    let rec parcour a l acc = match l with
        | [] -> acc
        | p::q -> parcour a q ((a,p)::acc)
    in
    let rec aux l acc = match l with
        | [] -> acc
        | p::q -> aux q ((parcour p l2 [])@acc)
    in aux l1 []

let f e = 
    let rec aux e = match e with 
        | Vide | Epsilon | L(_) -> []
        | Union(e1, e2) -> (aux e1)@(aux e2)
        | Concat (e1, e2) -> (produit (s e1) (p e2))@((aux e1)@(aux e2))
        | Etoile e1 -> (produit (s e1) (p e1))@(aux e1)
    in let l = aux e
    in List.fold_left (fun acc el -> el::(List.filter (fun el2 -> el2<>el) acc)) l l

let n_lettres e = 
    let rec aux e n = match e with
        | Epsilon | Vide -> n
        | L _ -> n + 1
        | Etoile e1 -> aux e1 n
        | Concat  (e1, e2) | Union (e1, e2) -> aux e1 (aux e2 n)
    in aux e 0

let lineariser e = 
    let i = ref 0 in
    let rec aux e = match e with 
        | Epsilon -> Epsilon
        | Vide -> Vide
        | L a -> i:= !i+1; L (a, !i)
        | Union (e1, e2) -> Union(aux e1, aux e2)
        | Concat (e1, e2) -> Concat(aux e1, aux e2)
        | Etoile e1 -> Etoile (aux e1)
    in aux e


type 'a automate = {
    delta : 'a list array array;
    finaux : bool array;
}

let glushkov e = 
    let n = n_lettres e in
    let a = {delta = Array.make_matrix (n+1) (n+1) []; finaux = Array.make (n+1) false} in
    let ne = lineariser e in
    List.iter (fun (b, i) -> a.delta.(0).(i) <- b::a.delta.(0).(i)) (p ne);
    List.iter (fun (_, i) -> a.finaux.(i) <- true) (s ne);
    a.finaux.(0) <- a_epsilon ne;
    List.iter (fun ((_,i),(b,j)) -> a.delta.(i).(j) <- b::a.delta.(i).(j)) (f ne);
    a
    
let sigma = Etoile (Union (L 'a', L 'b'))
