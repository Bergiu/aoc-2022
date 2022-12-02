Q={a0,a1,a10_0,a10_0_u,a10_1,a10_1_u,a1_2,a2,a3,a3_u,a4_0,a4_1,a4_u,a5_0,a5_1,a5_u,a6,a6_u,a7,a7_u,a8_0,a8_0_u,a8_1,a8_1_u,a9_0,a9_0_u,a9_1,a9_1_u,a_again,a_again!,a_again!2,a_again2,au1,au2,b0,q0}
Σ={0,1, ,|}
Γ={0,1, ,|,#}
q₀=q0
□=#
F={f1,f2,f3,f4}
δ=
                           space                 #                 0                 1                 |
              ------------------------------------------------------------------------------------------
         a0 |           (a0, ,R)          (f1,#,N)          (a0,0,R)          (a0,1,R)          (a1,|,R)
         a1 |              error          (f2,|,N)        (a1_2,0,R)        (a1_2,1,R)          (a0,|,R)
      a10_0 |        (a10_0, ,R)             error          (a3,0,L)          (a3,1,L)             error
    a10_0_u |        (a10_0, ,R)             error        (a3_u,0,L)        (a3_u,1,L)             error
      a10_1 |        (a10_1, ,R)             error          (a3,1,L)        (a3_u,0,L)             error
    a10_1_u |        (a10_0, ,R)             error        (a3_u,1,L)        (a3_u,1,L)             error
       a1_2 |         (a1_2, ,R)          (a2,|,L)        (a1_2,0,R)        (a1_2,1,R)          (a2,|,L)
         a2 |           (a3, ,L)             error          (a2,0,L)          (a2,1,L)             error
         a3 |           (a3, ,L)             error        (a4_0, ,R)        (a4_1, ,R)     (a_again, ,R)
       a3_u |         (a3_u, ,L)             error        (a4_1, ,R)        (a4_u, ,R)         (au1, ,R)
       a4_0 |         (a4_0, ,R)             error        (a5_0,0,L)        (a5_0,1,L)        (a5_0,|,L)
       a4_1 |         (a4_1, ,R)             error        (a5_1,0,L)        (a5_1,1,L)        (a5_1,|,L)
       a4_u |         (a4_u, ,R)             error        (a5_u,0,L)        (a5_u,1,L)        (a5_u,|,L)
       a5_0 |           (a6,0,L)             error             error             error             error
       a5_1 |           (a6,1,L)             error             error             error             error
       a5_u |         (a6_u,0,L)             error             error             error             error
         a6 |           (a6, ,L)             error          (a6,0,L)          (a6,1,L)          (a7,|,L)
       a6_u |         (a6_u, ,L)             error        (a6_u,0,L)        (a6_u,1,L)        (a7_u,|,L)
         a7 |           (a7, ,L)        (a8_0,#,R)        (a8_0, ,R)        (a8_1, ,R)        (a8_0,|,L)
       a7_u |         (a7_u, ,L)      (a8_0_u,#,R)      (a8_0_u, ,R)      (a8_1_u, ,R)          (f1,|,L)
       a8_0 |         (a8_0, ,R)             error             error             error        (a9_0,|,R)
     a8_0_u |       (a8_0_u, ,R)             error             error             error      (a9_0_u,|,R)
       a8_1 |         (a8_1, ,R)             error             error             error        (a9_1,|,R)
     a8_1_u |       (a8_1_u, ,R)             error             error             error      (a9_1_u,|,R)
       a9_0 |        (a10_0, ,R)             error        (a9_0,0,R)        (a9_0,1,R)             error
     a9_0_u |      (a10_0_u, ,R)             error      (a9_0_u,0,R)      (a9_0_u,1,R)             error
       a9_1 |        (a10_1, ,R)             error        (a9_1,0,R)        (a9_1,1,R)             error
     a9_1_u |      (a10_1_u, ,R)             error      (a9_1_u,0,R)      (a9_1_u,1,R)             error
    a_again |      (a_again, ,R)          (f3,#,N)     (a_again,0,R)     (a_again,1,R)    (a_again2,|,R)
   a_again! |     (a_again!, ,L)             error             error             error   (a_again!2,|,L)
  a_again!2 |           (a0, ,R)          (a0,#,R)   (a_again!2,0,L)   (a_again!2,1,L)          (a0,|,R)
   a_again2 |     (a_again2, ,R)          (f3,#,R)    (a_again!,0,L)    (a_again!,1,L)          (b0,|,R)
        au1 |          (au1, ,R)             error         (au2,0,L)         (au2,1,L)             error
        au2 |      (a_again,1,N)             error             error             error             error
         b0 |           (b0, ,R)          (f4,#,N)          (a0,0,N)          (a0,1,N)             error
         q0 |           (f1, ,N)          (f1,#,N)          (a0,0,R)          (a0,1,R)          (f1,|,N)


