// std::vector<std::vector<Vector>> delta(ntp, std::vector<Vector>(ngp,
// Vector(ncomp)));

// Making this more less error prone, we can define some alias types

// time_storage delta(/*Size of time domain*/
//                    ntp,
//                    /*Initialise with some number of Gauss points*/
//                    gauss_storage(/*Size of the Gauss domain*/
//                                  ngp,
//                                  /*Each component for the Gauss point*/
//                                  component_storage(ncomp)));

using Vector = Eigen::VectorXd;
using Matrix = Eigen::MatrixXd;
using matrix6 = Eigen::Matrix<double, 6, 6>;

namespace latin {

using vector_storage = Vector;
/** For each quadrature point store a component history */
using gauss_vector_storage = std::vector<vector_storage>;
/** For each time point store a quadrature history */
using time_vector_storage = std::vector<gauss_vector_storage>;

using matrix_storage = Matrix;
/** For each quadrature point store a component history */
using gauss_matrix_storage = std::vector<matrix_storage>;
/** For each time point store a quadrature history */
using time_matrix_storage = std::vector<gauss_matrix_storage>;

using matrix6_storage = matrix6;
/** For each quadrature point store a component history */
using gauss_matrix6_storage = std::vector<matrix6_storage>;
/** For each time point store a quadrature history */
using time_matrix6_storage = std::vector<gauss_matrix6_storage>;

// class time_domain {
// public:
//   void do_some_operation_on_domain() {
//     for (spatial_domain : spatial_domains) {
//       spatial_domain.update_gauss_points();
//     }
//   }
//
// private:
//   std::vector<spatial_domain> spatial_domains;
// };
//
// class spatial_domain {
// public:
//   void update_gauss_points();
//
// private:
// };

} // namespace latin
