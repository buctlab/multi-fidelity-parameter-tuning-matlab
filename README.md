# Multi-fidelity Parameter Tuning (Matlab)

## Structure
```plain
Algprithm (Algorithm.m):
|==Basic Algorithm:
   |==PSO.m
   |==GWO.m
|==Multi-fidelity Parameter Tuning:
   |==FidelityControlFunction.m
   |==MFOptimizedNIO.m
      |==MFOptimizedPSO.m
   |==MFMetaGWO.m

Cost Function:
|==SphereFunc.m
|==CEC14Func.m
   |==input_data
   |==cec14_func.cpp
   |==cec14_func.mexw64

Demo Runner Script:
|==DemoMF.m
```

## Run Demo
1. Go into project root: `<YOUR_WORKSPACE>/multi-fidelity-parameter-tuning-matlab`
2. Run the following command in Matlab window:
   ```
   DemoMF
   ```

## Compile CEC 2014
Run the following command to create CEC 2014 library in Matlab:
```
mex cec14_func.cpp -DWINDOWS
```
