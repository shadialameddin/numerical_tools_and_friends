#include "mex.h"
// mex vtkpipe/vtk_cpp.cpp -I"/usr/include/vtk/" -I"/usr/local/include/vtk/"
#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/Eigenvalues>
#include <eigen3/Eigen/Sparse>

#include <fstream>
#include <iostream>
#include <sstream> // std::ostringstream
#include <vector>

// #include "matrix.h"
// #include <typeinfo>

// VTK
#include "vtkUnstructuredGrid.h"
// #include <vtkXMLUnstructuredGrid.h>
#include <vtkPoints.h>
#include <vtkSmartPointer.h>
#include <vtkXMLUnstructuredGridWriter.h>

using vtkPointsP = vtkSmartPointer<vtkPoints>;
using vtkUnstructuredGridP = vtkSmartPointer<vtkUnstructuredGrid>;
using vtkHexahedronP = vtkSmartPointer<vtkHexahedron>;
using vtkXMLUnstructuredGridWriterP =
    vtkSmartPointer<vtkXMLUnstructuredGridWriter>;
using Node = std::vector<double>;
using Element = std::vector<int>;

// #define ngp int(*mxGetPr(prhs[0]))
#define connectivity prhs[0]
#define grid prhs[1]

using Matrix = Eigen::MatrixXd;
using Vector = Eigen::VectorXd;
using Matrix2 = Eigen::Matrix2d;
using Vector2 = Eigen::Vector2d;
using Matrix3 = Eigen::Matrix3d;
using Vector3 = Eigen::Vector3d;

void addTimeToVTKDataSet(double time, vtkUnstructuredGridP &dataSet) {
  // auto array = vtkDoubleArrayP::New();
  // array->SetName("TIME");
  // array->SetNumberOfTuples(1);
  // array->SetTuple1(0, time);
  // dataSet->GetFieldData()->AddArray(array);
}

void addElementsToVTKDataSet(const std::vector<Node> &nodes,
                             const std::vector<Element> &elements,
                             vtkPointsP &pts, vtkUnstructuredGridP &dataSet) {
  // Set the coordinates of the nodes
  // int id = 0;
  // for (const auto &node : nodes) {
  //   pts->SetPoint(id, node[0], node[1], node[2]);
  //   ++id;
  // }
  // // Set the element connectivities
  // auto hex = vtkHexahedronP::New(); // Assuming hex elements
  // for (const auto &element : elements) {
  //   // Get node ids and assign them to a hex element (ids start from 1)
  //   int nodeNum = 0;
  //   for (const auto &id : element) {
  //     hex->GetPointIds()->SetId(nodeNum, id - 1);
  //     ++nodeNum;
  //   }
  //   dataSet->InsertNextCell(hex->GetCellType(), hex->GetPointIds());
  // }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

  /* Acquire pointers to the input data */
  double *connectivity_ptr = mxGetPr(connectivity);
  auto connectivity_ndim = mxGetNumberOfDimensions(connectivity);
  auto connectivity_dims = mxGetDimensions(connectivity);

  double *grid_ptr = mxGetPr(grid);
  auto grid_ndim = mxGetNumberOfDimensions(grid);
  auto grid_dims = mxGetDimensions(grid);

  double time = 1;
  std::ostringstream fileName;
  // TODO outputVTK::writeGrid(double time,
  //                    const BoxArray& grid,
  //                    std::ostringstream& fileName)
  // ofstream fileName;
  // fileName.open("example.xml");

  // Create a writer
  auto writer = vtkXMLUnstructuredGridWriterP::New();
  // Append the default extension to the file name
  fileName << "." << writer->GetDefaultFileExtension();
  writer->SetFileName((fileName.str()).c_str());
  // Create a pointer to a VTK Unstructured Grid data set
  auto dataSet = vtkUnstructuredGridP::New();
  // Set up pointer to point data
  auto pts = vtkPointsP::New();
  // Count the total number of points to be saved
  int num_pts = grid_dims[0]; // TODO grid.getNumberOfPoints(); //
                              // Implementation is user-dependent
  pts->SetNumberOfPoints(num_pts);
  // Add the time
  addTimeToVTKDataSet(time, dataSet);
  // Get the nodes and elements that are used to describe the grid
  // std::vector<Node> nodes = grid.getNodes(); // TODO Implementation is
  // user-dependent
  std::vector<Node> nodes;
  for (size_t i = 0; i < 6; i++) {
    nodes.push_back(std::vector<double>(3, 1));
  }
  // = grid.getNodes(); // TODO Implementation is user-dependent

  // std::vector<Element> elements = connectivity_dims[0];
  std::vector<Element> elements;
  for (size_t i = 0; i < 6; i++) {
    elements.push_back(std::vector<int>(3, 1));
  }
  // TODO grid.getElements(); // Implementation is user-dependent
  // Add the processor boundaries to the unstructured grid cell data
  addElementsToVTKDataSet(nodes, elements, pts, dataSet);
  // Set the points
  dataSet->SetPoints(pts);
  // Remove unused memory
  dataSet->Squeeze();
  // Write the data
  writer->SetInput(dataSet);
  writer->SetDataModeToAscii(); // TODO SetDataModeToBinary().
  writer->Write();

  std::string s = fileName.str();
  std::cout << s << '\n';
  return;
}
