class PyFactorizationScheme:
    HERMES_FACTORIZE_FROM_SCRATCH,HERMES_REUSE_MATRIX_REORDERING,HERMES_REUSE_MATRIX_REORDERING_AND_SCALING,HERMES_REUSE_FACTORIZATION_COMPLETELY=range(4)

cdef class PyLinearSolverReal: #abstract
  def __dealloc__(self):
    del self.thisptr
  def solve(self):
    return self.thisptr.solve()
  def get_sln_vector(self):
    v=[]
    cdef double * cv = self.thisptr.get_sln_vector()
    for i in range(self.thisptr.get_matrix_size()):
      v.append(cv[i])
    return v
  def get_error(self):
    return self.thisptr.get_error()
  def get_time(self):
    return self.thisptr.get_time()
  def set_factorization_scheme(self, reuse_scheme=None):
    if reuse_scheme:
      self.thisptr.set_factorization_scheme(reuse_scheme)
    else:
      self.thisptr.set_factorization_scheme()

cdef class PyLinearSolverComplex: #abstract
  def __dealloc__(self):
    del self.thisptr
  def solve(self):
    return self.thisptr.solve()
  def get_sln_vector(self):
    v=[]
    cdef cComplex[double] * cv = self.thisptr.get_sln_vector()
    for i in range(self.thisptr.get_matrix_size()):
      v.append(pcomplex(cv[i]))
    return v
  def get_error(self):
    return self.thisptr.get_error()
  def get_time(self):
    return self.thisptr.get_time()
  def set_factorization_scheme(self, reuse_scheme=None):
    if reuse_scheme:
      self.thisptr.set_factorization_scheme(reuse_scheme)
    else:
      self.thisptr.set_factorization_scheme()

cdef class PyDirectSolverReal(PyLinearSolverReal): #abstract
    pass

cdef class PyDirectSolverComplex(PyLinearSolverComplex): #abstract
    pass

cdef class PyIterSolverReal(PyLinearSolverReal): #abstract
  cdef get_num_iters(self):
    return (<IterSolver[double]*> self.thisptr).get_num_iters()
  cdef get_residual(self):
    return (<IterSolver[double]*> self.thisptr).get_residual()
  cdef set_tolerance(self, double tol):
    (<IterSolver[double]*> self.thisptr).set_tolerance(tol)
  cdef set_max_iters(self, int iters):
    (<IterSolver[double]*> self.thisptr).set_max_iters(iters)
  cdef set_precond(self, pc):
    if isinstance(pc,PyPrecondReal):
      (<IterSolver[double]*> self.thisptr).set_precond((<PyPrecondReal> pc).thisptr)
    else:
      (<IterSolver[double]*> self.thisptr).set_precond(<char * > pc)
#
#  cdef cppclass create_linear_solver[Scalar]:
#    create_linear_solver(MatrixSolverType matrix_solver_type, Matrix[Scalar]* matrix, Vector[Scalar]* rhs)

