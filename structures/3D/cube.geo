#comment
algebraic3d

solid cube = orthobrick(0 ,  0 , 0  ; 1, 1, 1 )  -bc=3 - maxh =10;

solid struct = cube -bc=3;

tlo struct- maxh =1;
