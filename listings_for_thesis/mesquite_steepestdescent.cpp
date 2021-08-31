#include "Mesquite_all_headers.hpp"
#include <ostream>
#include <iostream>
using namespace Mesquite;
using namespace std;

const char INPUT_FILE[] = "input_mesh.vtk";
const char OUTPUT_FILE[] = "output_mesh.vtk";

int main()
{
    MsqPrintError err(cout);
    MeshImpl mesh;
    mesh.read_vtk(INPUT_FILE, err);
    
    IdealWeightMeanRatio mean;
    LPtoPTemplate obj_func(&mean, 1, err);
    SteepestDescent sd(&obj_func);
    sd.use_element_on_vertex_patch();
    
    TerminationCriterion tc;
    tc.add_iteration_limit(3) ;
    sd.set_outer_termination_criterion(&tc);

    QualityAssessor stopqa = QualityAssessor(&mean);

    InstructionQueue queue;
    queue.add_quality_assessor(&stopqa, err);
    queue.set_master_quality_improver(&sd, err);
    queue.add_quality_assessor(&stopqa, err);
    queue.run_instructions(&mesh, err);
    
    mesh.write_vtk(OUTPUT_FILE, err);
    return 0;
}
