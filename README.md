# The Analysis of the Instability of minimal problems.
__Introduction__

This is the reaseach code of the project: Analysis of the Instability of Minimal Problem in Computer Vision. 

The related paper can be reached on ArXiv: [Missing link]

The authors include:

[Joe Kileel, Ph.D.](https://web.ma.utexas.edu/users/jkileel/)

[Benjamin Kimia, Ph.D.](https://vivo.brown.edu/display/bkimia)

[Hongyi Fan](http://vision2.lems.brown.edu/graduateStudents/hongyi/Hongyi%20Fan.html)


__Prerequisite__

To use this repository you need: 

+ [MATLAB](https://www.mathworks.com/products/matlab.html)
+ [Julia](https://julialang.org/) and [HomotopyContinuation.jl](https://www.juliahomotopycontinuation.org/)
+ [Macaulay2](http://www2.macaulay2.com/Macaulay2/)

__Important Note__

This repository is still in development. 

---

### File List and Usage

__1. Generating 6.5D Degenerate Curve using the method described in the paper__

You can generate the synthetic data and related intermediate result first with `main_65Dcurve.m` with Matlab; then run `curve65D.jl` to generate the curve with Julia. Finally, one can use the related drawing code in `main_65Dcurve.m` to show the 6.5D degenerate curve.

__2. Generating 4.5D Degenerate Curve using the method described in the paper__

You can generate the synthetic data and related intermediate result first with `main_45Dcurve.m` with Matlab; then run `curve45D.jl` to generate the curve with Julia. Finally, one can use the related drawing code in `main_45Dcurve.m` to show the 4.5D degenerate curve.

__3. Batched Experiment reported in the paper__

`Exp_E.m` and `Exp_F.m` are the code for generating the random experiment data of Essential matrix and Fundamental matrix respectively. After generating the data, the statistics of the distances from the target points to the degerneated curve can be computed using Julia script `curve45D_SynExp.jl` and `curve65D_SynExp.jl` . 

__4. Symbolic 6.5D curve generator__

`shortFdisc.m2` is the Macaulay2 code for quickly generating the symbolic expression of 6.5D curve. To use this with custom data, one needs to change line 48 and 49 with the coordinates with image points on two images, (X for the first camera, and Y for the second camera). To reach the best result, one also needs to specify a high precision of the number. For example, one can replace line 48 with
```
X = matrix{{1p100,2p100,3p100,4p100,5p100,6p100,7p100},{1p100,2p100,3p100,4p100,5p100,6p100,7p100}}
```
indicating image points (1,1), (2,2), (3,3), ..., (7,7).
 
