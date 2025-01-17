cdef extern from "views/linearizer.h" namespace "Hermes::Hermes2D::Views":
  cdef cppclass Linearizer : #public LinearizerBase
    Linearizer()
    void process_solution(MeshFunction[double]* sln, int item, double eps)
    void process_solution(MeshFunction[double]* sln, int item)
    void process_solution(MeshFunction[double]* sln)
    void save_solution_vtk(MeshFunction[double]* sln, char* filename, char* quantity_name, bool mode_3D, int item, double eps)
    void save_solution_vtk(MeshFunction[double]* sln, char* filename, char* quantity_name, bool mode_3D, int item)
    void save_solution_vtk(MeshFunction[double]* sln, char* filename, char* quantity_name, bool mode_3D)
    void save_solution_vtk(MeshFunction[double]* sln, char* filename, char* quantity_name)
    void set_displacement(MeshFunction[double]* xdisp, MeshFunction[double]* ydisp, double dmult)
    void set_displacement(MeshFunction[double]* xdisp, MeshFunction[double]* ydisp)
    void calc_vertices_aabb(double* min_x, double* max_x, double* min_y, double* max_y)
    int get_num_vertices()
    double3* get_vertices()
