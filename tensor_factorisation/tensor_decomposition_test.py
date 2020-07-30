""""
H-matrices:
Useful to invert matrices or multiply H-matrices
matrix multiplication, factorization or inversion can be approximated in {\displaystyle O(nk^{\alpha }\,\log(n)^{\beta })}O(nk^{\alpha }\,\log(n)^{\beta })
 operations, where {\displaystyle \alpha ,\beta \in \{1,2,3\}.}\alpha ,\beta \in \{1,2,3\}.

H2-matrices
In order to treat very large problems, the structure of hierarchical matrices can be improved: H2-matrices [17] [18] replace the general low-rank structure
 of the blocks by a hierarchical representation closely related to the fast multipole method in order to reduce the storage complexity to {\displaystyle O(nk)}O(nk).

Skeleton decomposition:
X = C U R
 
Tensor decomposition:

- Tucker decomposition via Higher Order Orthogonal Iteration (HOI): core tensor and factor matrices
Tucker decomposition via Higher Order SVD (HOSVD): core tensor and factor matrices

- Tensor Canonical Polyadic Decomposition
aka. Kruskal, CANDECOMP-PARAFAC, CP, PARAFAC or PGD
Special case of Tucker with superdiagonal core tensor
CP-als: alternating least squares algorithm

- Matrix-Product-State / Tensor-Train Decomposition
decompose a tensor into a multiplication of 3D tensors (each dimension is split into 3D tensor)
""" ""
from data_reader_writer.read_h5 import load_reduced_basis
from utilities import *
import tensorly as tl

np.random.seed(0)
name = 'laminate_sphere'
file_name = data_dir + '/{}/{}.h5'.format(name, name)
output_dir = root_dir + '/data_output/{}'.format(name)
N = 80
number_of_phases, material_index, integration_coefficients, strain_modes, singular_values = load_reduced_basis(file_name, N)
strain_modes = scale_modes(strain_modes, singular_values)
x_original = np.copy(strain_modes.reshape(strain_modes.shape[0], -1))
#############################################################
#############################################################
#############################################################

from tensorly.decomposition import tucker, parafac
tucker_tensor, factors = tucker(strain_modes, rank=[60, 6, 60])
app_E = tl.tucker_to_tensor((tucker_tensor, factors))
print(relative_error(strain_modes - app_E, strain_modes, lambda x: LA.norm(x)) * 100)
print((np.count_nonzero(tucker_tensor) + np.sum([np.count_nonzero(f) for f in factors])) / np.count_nonzero(strain_modes) * 100,
      '%')

factors = parafac(x_original, rank=90)
app_E = tl.kruskal_to_tensor((factors))
print(relative_error(x_original - app_E, x_original, lambda x: LA.norm(x)) * 100)
# print(np.sum([np.count_nonzero(f) for f in factors]) / np.count_nonzero(strain_modes) * 100, '%')

from tensorly.decomposition import matrix_product_state
factors = matrix_product_state(strain_modes, rank=[1, 30, 50, 1])
len(factors)
app_E = tl.mps_to_tensor(factors)
print(relative_error(strain_modes - app_E, strain_modes, lambda x: LA.norm(x)) * 100)
# print(np.sum([np.count_nonzero(f) for f in factors]) / np.count_nonzero(strain_modes) * 100, '%')
# [f.shape for f in factors]

from tensorly.contrib.sparse.decomposition import tucker, parafac
tucker_tensor, factors = tucker(strain_modes, rank=[60, 6, 60])
app_E = tl.tucker_to_tensor((tucker_tensor, factors))
print(relative_error(strain_modes - app_E, strain_modes, lambda x: LA.norm(x)) * 100)

# from tensorly.contrib.sparse.decomposition import partial_tucker
# tucker_tensor, factors = partial_tucker(strain_modes,modes=[6,6,6], rank=[60, 6, 60])
# app_E = tl.tucker_to_tensor((tucker_tensor, factors))
# print(relative_error(strain_modes - app_E, strain_modes, lambda x: LA.norm(x)) * 100)

#%% pip install -e .
import pymf.kmeans as kmeans
import numpy as np
data = np.array([[1.0, 0.0, 2.0], [0.0, 1.0, 1.0]])
mdl = kmeans.Kmeans(data, num_bases=2)
mdl.factorize(niter=10)  # optimize for WH
V_approx = np.dot(mdl.W, mdl.H)  # V = WH

import numpy as np
test_data = np.array([[1.0], [0.3]])
mdl_test = kmeans.Kmeans(test_data, num_bases=2)
mdl_test.W = mdl.W  # mdl.W -> existing basis W
mdl_test.factorize(compute_w=False)
test_datx_approx = np.dot(mdl.W, mdl_test.H)

# Example Archetypal Analysis
from pymf.aa import AA
import numpy as np
mdl = AA(data, num_bases=2, iter=50)
mdl.factorize()
V_approx = np.dot(mdl.W, mdl.H)

from pymf.sivm import SIVM  # uses [6]
sivm_mdl = SIVM(data, num_bases=10)
sivm_mdl.factorize()
sivm_mdl.W
sivm_mdl.H
