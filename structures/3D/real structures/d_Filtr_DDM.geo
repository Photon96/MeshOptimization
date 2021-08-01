algebraic3d

solid p1 = plane (0,0,0; -1,0, 0 ) -bc=1- maxh = 1.5;
solid p2 = plane (78.5 ,0 , 0; 1, 0, 0) -bc=2- maxh = 1.5;

solid w1 = plane (20.25,0, 0 ; 1,0,0) -bc=4- maxh = 0.8;
solid w1b = plane (20.25 ,0 , 0; -1, 0, 0) -bc=4- maxh = 0.8;
solid w2 = plane (29.75,0, 0 ; 1,0,0) -bc=5- maxh = 0.8;
solid w2b = plane (29.75 ,0 , 0; -1, 0, 0) -bc=5- maxh = 0.8;
solid w3 = plane (39.25,0, 0; 1,0,0) -bc=6- maxh = 0.8;
solid w3b = plane (39.25 ,0 , 0; -1, 0, 0) -bc=6- maxh = 0.8;
solid w4 = plane (48.75,0, 0; 1,0,0) -bc=7- maxh = 0.8;
solid w4b = plane (48.75 ,0 , 0; -1, 0, 0) -bc=7- maxh = 0.8;
solid w5 = plane (58.25,0, 0; 1,0,0) -bc=8- maxh = 0.8;
solid w5b = plane (58.25 ,0 , 0; -1, 0, 0) -bc=8- maxh = 0.8;

solid f1 = orthobrick(0 ,  0 , 0  ;  20, 9.52, 19.05) -bc=3 - maxh =3;
solid f2 = orthobrick(58.5 ,  0 , 0  ;  78.5, 9.52,19.05 ) -bc=3 - maxh =3;

solid rez1 = orthobrick(20.5,  1.305 , 5.025   ;   29.5  , 8.215, 14.025) -bc=3 - maxh =3;
solid rez2 = orthobrick(30  ,  0.795 , 5.025 ;      39, 8.725, 14.025) -bc=3 - maxh =3;
solid rez3 = orthobrick(39.5  ,  0.795 , 5.025  ;    48.5 , 8.725, 14.025) -bc=3 - maxh =3;
solid rez4 = orthobrick( 49  ,  1.305 , 5.025 ;      58, 8.215, 14.025 ) -bc=3 - maxh =3;

solid prz1 = orthobrick( 20  ,  1.305 , 5.025  ; 20.5 , 8.215, 14.025) -bc=3 - maxh =0.8;
solid prz2 = orthobrick( 29.5 , 1.795 , 6.595  ;  30, 7.725, 12.455) -bc=3 - maxh =0.8;
solid prz3 = orthobrick( 39    , 2.335 ,  6.9  ;  39.5, 7.185, 12.15) -bc=3 - maxh =0.8;
solid prz4 = orthobrick( 48.5, 1.795 ,   6.595  ;  49, 7.725, 12.455) -bc=3 - maxh =0.8;
solid prz5 = orthobrick( 58   ,  1.305 ,  5.025  ; 58.5, 8.215, 14.025) -bc=3 - maxh =0.8;

solid pc1 = plane(25.5, 4.76,  5.025; 0 , 0,  -1)- bc=3;
solid pc2 = plane( 25.5, 4.76, 7.335; 0, 0, 1)- bc=20;
solid pc3 = plane( 25.5, 4.76, 7.335; 0, 0, -1)- bc=20;
solid pc4 = plane(  25.5, 4.76, 9.635; 0, 0, 1)- bc=20;


solid c1 = cylinder ( 25 , 4.76, 5.025;  25 , 4.76, 7; 1.75 ) - bc=20;
solid podst1 = c1 and pc1 and pc2 - maxh =0.8; 

solid c2 = cylinder (  25 , 4.76, 5.025; 25, 4.76, 7 ; 2.55 ) - bc=20;
solid rezo1 = c2 and pc3 and pc4 - maxh =0.6; 

solid c3 = cylinder (34.5 , 4.76, 5.025; 34.5, 4.76,  7; 1.75) - bc=20;
solid podst2 = c3 and pc1 and pc2 - maxh =0.8; 

solid c4 = cylinder (  34.5, 4.76,5.025;  34.5 , 4.76, 7; 2.55 ) - bc=20;
solid rezo2 = c4 and pc3 and pc4 - maxh =0.6; 

solid c5 = cylinder ( 44, 4.76, 5.025; 44, 4.76, 7 ; 1.75) - bc=20;
solid podst3 = c5 and pc1 and pc2 - maxh = 0.8; 

solid c6 = cylinder (  44, 4.76, 5.025; 44 , 4.76, 7; 2.55 ) - bc=20;
solid rezo3 = c6 and pc3 and pc4 - maxh =0.6; 

solid c7 = cylinder (  53.5, 4.76, 5.025;  53.5 , 4.76, 7; 1.75) - bc=20;
solid podst4 = c7 and pc1 and pc2 - maxh = 0.8 ; 

solid c8 = cylinder (  53.5, 4.76, 5.025; 53.5, 4.76,  7; 2.55) - bc=20;
solid rezo4 = c8 and pc3 and pc4 - maxh =0.6; 

solid strukt = (f1 or f2 or rez1 or rez2 or rez3 or rez4 or prz1 or prz2 or prz3 or prz4 or prz5 ) and not podst1 and not rezo1 and not podst2 and not rezo2 and not podst3 and not rezo3  and not podst4 and not rezo4-bc=3;

solid MM1 = strukt and p1  and w1 -bc = 3;
solid MM2 = strukt and w1b and w2 -bc = 3;
solid MM3 = strukt and w2b and w3 -bc = 3;
solid MM4 = strukt and w3b and w4 -bc = 3;
solid MM5 = strukt and w4b and w5 -bc = 3;
solid MM6 = strukt and w5b and p2 -bc = 3;

tlo MM1;
tlo MM2;
tlo podst1;
tlo rezo1;

tlo MM3;
tlo podst2;
tlo rezo2;

tlo MM4;
tlo podst3;
tlo rezo3;

tlo MM5;
tlo podst4;
tlo rezo4;

tlo MM6;
