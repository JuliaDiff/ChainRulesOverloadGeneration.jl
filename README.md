<img src="https://rawcdn.githack.com/JuliaDiff/ChainRulesCore.jl/b0b8dbf26807f8f6bc1a3c073b6720b8d90a8cd4/docs/src/assets/logo.svg" width="256"/>

# ChainRulesOverloadGeneration

[![Build Status](https://github.com/JuliaDiff/ChainRulesOverloadGeneration.jl/workflows/CI/badge.svg)](https://github.com/JuliaDiff/ChainRulesOverloadGeneration.jl/actions?query=workflow:CI)
[![Coverage](https://codecov.io/gh/JuliaDiff/ChainRulesOverloadGeneration.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaDiff/ChainRulesOverloadGeneration.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)
[![DOI](https://zenodo.org/badge/199721843.svg)](https://zenodo.org/badge/latestdoi/199721843)

**Docs:**
[![](https://img.shields.io/badge/docs-master-blue.svg)](https://juliadiff.org/ChainRulesOverloadGeneration.jl/dev)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliadiff.org/ChainRulesOverloadGeneration.jl/stable)

The ChainRulesOverloadGeneration package provides a suite of methods for using [ChainRulesCore.jl](https://github.com/JuliaDiff/ChainRulesCore.jl) rules in operator overloading AD systems.
It tracks what rules are defined at any point in time, and lets you trigger functions to which can use `@eval` in order to define the matching operator overloads.
