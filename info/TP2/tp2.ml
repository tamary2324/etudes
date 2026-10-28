type afdc = {
    initial : int;
    finaux : int list;
    delta : int array array
}
(*1*)
let a1 = {initial = 0; finaux = [1]; delta = [|[|1;0|];[|0;1|]|]}
let a2 = {initial = 0; finaux = [2]; delta = [|[|0;1|];[|1;2|];[|2;0|]|]}
let a3 = {initial = 0; finaux = [1;3]; delta = [|[|1;2|];[|0;1|];[|3;2|];[|2;3|]|]}

(*2*)
let rec delta_etoile a q u = match u with
    | [] -> q
    | p::l -> delta_etoile a a.delta.(q).(p) l

(*3*)
let accepte a u = 
    let f = delta_etoile a a.initial u in 
    List.exists (fun m -> m = f) a.finaux

(*O(|u|+|a.finaux|)*)

(*4*)
let complementaire a = 
    let n = Array.length a.delta in
    let rec aux k l = 
        if k >= n then l
        else if List.exists (fun e -> e = k) a.finaux then aux (k+1) l
        else aux (k+1) (k::l) 
    in {initial = a.initial; finaux = aux 0 []; delta = a.delta}

let accessible a = 
    let len = Array.length a.delta.(0) in
    let n = Array.length a.delta in
    let seen = Array.make n false in
    let rec prof q =  
        seen.(q)<-true;
        for i = 0 to len-1 do 
            if not seen.(a.delta.(q).(i)) then prof a.delta.(q).(i)
        done
    in 
    let rec aux k l = 
        if k >= n then l
        else if seen.(k) then aux (k+1) (k::l) 
        else aux (k+1) l
    in prof a.initial;
    aux 0 []
(*List.for_all2 pas produit cartésien*)
let vide a = List.for_all2 (fun v u -> v <> u) (accessible a) a.finaux 

let inter a b = 
    let n = Array.length a.delta in
    let p = Array.length b.delta in
    let len = Array.length a.delta.(0) in
    let rec final l1 l2 acc = match l1, l2 with
        | _, [] -> acc
        | [], h::t -> final a.finaux t acc
        | h1::t1, h2::t2 -> final t1 l2 (h1*p + h2::acc)
    in let delta_cartesien () = 
        let delta = Array.make (n*p) [||] in
        for i=0 to n-1 do
            for j=0 to p-1 do
                delta.(i*p+j) <- Array.make (len) 0;
                for k=0 to len-1 do
                    delta.(i*p+j).(k) <- a.delta.(i).(k)*p + b.delta.(j).(k)
                done
            done
        done;
        delta
    in {initial = a.initial*p + b.initial; finaux = final a.finaux b.finaux []; delta = delta_cartesien ()}

let inclus a b = vide (inter a (complementaire b))

let equivalent a b = (inclus a b) && (inclus b a )