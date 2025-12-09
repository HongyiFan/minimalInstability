# Analysis of the Instability of Minimal Problems

## Introduction

This repository contains the research code for the following papers:

Fan, Hongyi, Joe Kileel, and Benjamin Kimia. "On the instability of relative pose estimation and RANSAC's role." Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition. 2022.

Fan, Hongyi, Joe Kileel, and Benjamin Kimia. "Condition numbers in multiview geometry,  instability in relative pose estimation, and RANSAC." To appear in IEEE Transactions on Pattern Analysis and Machine Intelligence. 2025.

The authors are:
- [Hongyi Fan, Ph.D.](https://scholar.google.com/citations?user=aoz5NaQAAAAJ&hl=en&oi=ao)
- [Joe Kileel, Ph.D.](https://web.ma.utexas.edu/users/jkileel/)  
- [Benjamin Kimia, Ph.D.](https://vivo.brown.edu/display/bkimia)  


## Prerequisites

To use this repository, you will need:

- [MATLAB](https://www.mathworks.com/products/matlab.html)  
- [Julia](https://julialang.org/) and the package [HomotopyContinuation.jl](https://www.juliahomotopycontinuation.org/)  
- [Macaulay2](http://www2.macaulay2.com/Macaulay2/)

## Important Note

This repository is still under active development.

---

## File List and Usage

### 1. Generating the 6.5D Degenerate Curve

To generate synthetic data and intermediate results, first run `main_65Dcurve.m` in MATLAB.  
Next, run `curve65D.jl` in Julia to generate the curve.  
Finally, use the visualization code in `main_65Dcurve.m` to display the 6.5D degenerate curve.

### 2. Generating the 4.5D Degenerate Curve

To generate synthetic data and intermediate results, run `main_45Dcurve.m` in MATLAB.  
Then run `curve45D.jl` in Julia to compute the curve.  
Use the drawing code in `main_45Dcurve.m` to visualize the 4.5D degenerate curve.

### 3. Batched Experiments Reported in the Paper

`Exp_E.m` and `Exp_F.m` generate the random experiment data for the Essential matrix and Fundamental matrix, respectively.  
After generating the data, use the Julia scripts `curve45D_SynExp.jl` and `curve65D_SynExp.jl` to compute statistics for the distances from target points to the degenerate curves.

### 4. Symbolic 6.5D Curve Generator

`shortFdisc.m2` is a Macaulay2 script that quickly generates the symbolic expression of the 6.5D curve.  
To use custom data, modify lines **48** and **49** with the coordinates of the image points from the two images (X for the first camera, Y for the second).

For best results, specify high-precision numbers. For example, replace line 48 with:

```macaulay2
X = matrix{{1p100,2p100,3p100,4p100,5p100,6p100,7p100},
           {1p100,2p100,3p100,4p100,5p100,6p100,7p100}}
```
This corresponds to the image points (1,1), (2,2), (3,3), …, (7,7).
