cdef extern from "mesh/refmap.h" namespace "Hermes::Hermes2D":
  cdef cppclass RefMap: # public Transformable
    RefMap()
    void set_quad_2d(Quad2D* quad_2d)
    Quad1D* get_quad_1d()
    void set_active_element(Element* e)
    double3* get_tangent(int edge, int order)
    double3* get_tangent(int edge)
    void untransform(Element* e, double x, double y, double& xi1, double& xi2)
    double* get_phys_x(int order)
    bool is_jacobian_const()
    double get_const_jacobian()
    double* get_jacobian(int order)
    int get_inv_ref_order()
