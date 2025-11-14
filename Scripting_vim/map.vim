
let vals = [1,7,13,25]
let sq = map(vals, 'v:val * v:val')
echo "vals: ".string(vals) "sq: ".string(sq)
"[1, 49, 169, 625] [1, 49, 169, 625]

let vals1 = [1,7,13,25]
let sq1 = map(copy(vals1), 'v:val * v:val')
echo "vals1: ".string(vals1) "sq1: ".string(sq1)
" a deepcopy() would be necessay if list was than 1D
