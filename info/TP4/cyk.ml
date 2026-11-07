type grammaire = {
  n_variables : int;
  regles1 : (int * char) list;
  regles2 : (int * int * int) list;
  epsilon : bool;
}

let g0 =
  {
    n_variables = 5;
    regles1 = [ (0, 'b'); (1, 'a'); (2, 'b'); (4, 'a') ];
    regles2 = [ (0, 1, 2); (0, 2, 1); (0, 3, 1); (1, 1, 4); (3, 1, 2) ];
    epsilon = false;
  }

let init g u =
  let n = String.length u in
  let k = List.length g.regles2 in
  let t = Array.init_matrix (n + 1) n (fun x y -> Array.make k false) in
  String.iteri
    (fun j c -> List.iter (fun (i, a) -> t.(1).(j).(i) <- a = c) g.regles1)
    u;
  t

let cyk g u =
  let n = String.length u in
  let t = init g u in
  let k = List.length g.regles2 in
  for l = 2 to n - 1 do
    for d = 0 to n - l - 1 do
      for p = 1 to l - 1 do
        List.iter
          (fun (i, j, k) ->
            if t.(p).(d).(j) && t.(l - p).(d + p).(k) then t.(l).(d).(i) <- true)
          g.regles2
      done
    done
  done
