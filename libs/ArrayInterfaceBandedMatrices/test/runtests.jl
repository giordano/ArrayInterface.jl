
using ArrayInterfaceCore
using ArrayInterfaceBandedMatrices
using BandedMatrices
using Test

B=BandedMatrix(Ones(5,5), (-1,2))
B[band(1)].=[1,2,3,4]
B[band(2)].=[5,6,7]
@test ArrayInterfaceCore.has_sparsestruct(B)
rowind,colind=ArrayInterfaceCore.findstructralnz(B)
@test [B[rowind[i],colind[i]] for i in 1:length(rowind)]==[5,6,7,1,2,3,4]
B=BandedMatrix(Ones(4,6), (-1,2))
B[band(1)].=[1,2,3,4]
B[band(2)].=[5,6,7,8]
rowind,colind=ArrayInterfaceCore.findstructralnz(B)
@test [B[rowind[i],colind[i]] for i in 1:length(rowind)]==[5,6,7,8,1,2,3,4]
@test ArrayInterfaceCore.isstructured(typeof(B))
@test ArrayInterfaceCore.fast_matrix_colors(typeof(B))

