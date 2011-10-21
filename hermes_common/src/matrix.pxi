#def void ludcmp(double **a, int n, int *indx, double *d)
#def void choldc(double **a, int n, double p[])

class PyEMatrixDumpFormat:
  DF_MATLAB_SPARSE, DF_PLAIN_ASCII, DF_HERMES_BIN, DF_NATIVE, DF_MATRIX_MARKET=range(5)

cdef class PyMatrixReal: #abstract
  def __dealloc__(self):
    del self.thisptr

  def get_size(self):
    return self.thisptr.get_size()
  def alloc(self):
    self.thisptr.alloc()
  def free(self):
    self.thisptr.free()
  def get(self, unsigned int m, unsigned int n):
    self.thisptr.get(m, n)
  def zero(self):
    self.thisptr.zero()
  def add_to_diagonal(self, double v):
    self.thisptr.add_to_diagonal(v)
  def add(self, unsigned int m, unsigned int n, mat, rows=None, cols=None):
    cdef int *crows
    cdef int *ccols
    cdef double **cmat
    cdef int i
    cdef int j
    if not rows:
      self.thisptr.add(m, n, mat)
    else:
      crows=intArray(rows)
      ccols=intArray(cols)
      cmat=double2Array(mat)

      self.thisptr.add(m, n, cmat, crows, ccols)
      delInts(crows)
      delInts(ccols)
      del2Doubles(cmat,len(mat))

  def dump(self, file, char *var_name, fmt=None):
    cdef FILE * f = PyFile_AsFile(file)
    if fmt:
      return self.thisptr.dump(f, var_name,fmt)
    else:
      return self.thisptr.dump(f, var_name)
  def get_matrix_size(self):
    return self.thisptr.get_matrix_size()

cdef class PyMatrixComplex: #abstract
  def __dealloc__(self):
    del self.thisptr

  def get_size(self):
    return self.thisptr.get_size()
  def alloc(self):
    self.thisptr.alloc()
  def free(self):
    self.thisptr.free()
  def get(self, unsigned int m, unsigned int n):
    self.thisptr.get(m, n)
  def zero(self):
    self.thisptr.zero()
  def add_to_diagonal(self, v):
    self.thisptr.add_to_diagonal(cComplex[double](v.real,v.imag))
  def add(self, unsigned int m, unsigned int n, mat, rows=None, cols=None):
    cdef int *crows
    cdef int *ccols
    cdef cComplex[double] **cmat
    cdef int i
    cdef int j
    if not rows:
      self.thisptr.add(m, n, cComplex[double](mat.real,mat.imag))
    else:
      crows=intArray(rows)
      ccols=intArray(cols)
      cmat=complex2Array(mat)

      self.thisptr.add(m, n, cmat, crows, ccols)
      delInts(crows)
      delInts(ccols)
      del2Complexes(cmat,len(mat))

  def dump(self, file, char *var_name, fmt=None):
    cdef FILE * f = PyFile_AsFile(file)
    if fmt:
      return self.thisptr.dump(f, var_name,fmt)
    else:
      return self.thisptr.dump(f, var_name)
  def get_matrix_size(self):
    return self.thisptr.get_matrix_size()

cdef class PySparseMatrixReal(PyMatrixReal): #abstract
  def prealloc(self,unsigned int n):
    (<SparseMatrix[double] *> self.thisptr).prealloc(n)
  def pre_add_ij(self,unsigned int row, unsigned int col):
    (<SparseMatrix[double] *> self.thisptr).pre_add_ij(row, col)
  def finish(self):
    (<SparseMatrix[double] *> self.thisptr).finish()
  def add_sparse_matrix(self,PySparseMatrixReal mat):
    (<SparseMatrix[double] *> self.thisptr).add_sparse_matrix(<SparseMatrix[double]*> mat.thisptr)
  def add_sparse_to_diagonal_blocks(self,int num_stages, PySparseMatrixReal mat):
    (<SparseMatrix[double] *> self.thisptr).add_sparse_to_diagonal_blocks(num_stages, <SparseMatrix[double]*> mat.thisptr)
  def get_num_row_entries(self,row):
    return (<SparseMatrix[double] *> self.thisptr).get_num_row_entries(row)

  """n_entries doesn't work use len(vals) instead, vals must be a list"""
  def extract_row_copy(self,unsigned int row, unsigned int l,n_entries, vals,idxs):
    cdef unsigned int * cidxs=<unsigned int*> intArray(idxs)
    cdef double * buff=<double*> newBuffer(sizeof(double)*l)
    cdef int i
    (<SparseMatrix[double] *> self.thisptr).extract_row_copy(row, l, n_entries, buff,cidxs)
    for i in range(n_entries):
      vals.append(buff[i])
    delInts(<int*>cidxs) 
    delDoubles(buff) 

  def get_num_col_entries(self,unsigned int col):
    return (<SparseMatrix[double] *> self.thisptr).get_num_col_entries(col)

  """n_entries doesn't work use len(vals) instead, vals must be a list""" #TODO returning values of arguments
  def extract_col_copy(self,unsigned int col, unsigned int l,n_entries, vals,idxs):
    cdef unsigned int * cidxs=<unsigned int*> intArray(idxs)
    cdef double * buff=<double*> newBuffer(sizeof(double)*l)
    cdef int i
    (<SparseMatrix[double] *> self.thisptr).extract_col_copy(col, l, n_entries, buff,cidxs)
    for i in range(n_entries):
      vals.append(buff[i])
    delInts(<int*>cidxs) 
    delDoubles(buff) 

  def multiply_with_vector(self, vector_in, vector_out):
    cdef double * cvectorin = doubleArray(vector_in)
    cdef double * cvectorout = <double*> newBuffer(sizeof(double)*len(vector_in))
    cdef int i
    (<SparseMatrix[double] *> self.thisptr).multiply_with_vector(cvectorin, cvectorout)
    for i in range(len(vector_in)):
      vector_out.append(cvectorout[i])
    delDoubles(cvectorin)
    delDoubles(cvectorout)

  def multiply_with_Scalar(self,double value):
    (<SparseMatrix[double] *> self.thisptr).multiply_with_Scalar(value)
  def duplicate(self):
    dup=PySparseMatrixReal()
    dup.thisptr= (<SparseMatrix[double] *> self.thisptr).duplicate()
    return dup

  def get_fill_in(self):
    return (<SparseMatrix[double] *> self.thisptr).get_fill_in()
#  def row_storage
#    unsigned row_storage
#  def col_storage
#    unsigned col_storage
  def get_nnz(self):
    return (<SparseMatrix[double] *> self.thisptr).get_nnz()

#
#  cdef cppclass Vector[Scalar]: #abstract
#    void alloc(unsigned int ndofs)
#    void free()
#    void finish()
#    Scalar get(unsigned int idx)
#    void extract(Scalar *v)
#    void zero()
#    void change_sign()
#    void set(unsigned int idx, Scalar y)
#    void add(unsigned int idx, Scalar y)
#    void add_vector(Vector[Scalar]* vec)
#    void add_vector(Scalar* vec)
#    void add(unsigned int n, unsigned int *idx, Scalar *y)
#    unsigned int length()
#    bool dump(FILE *file, char *var_name,EMatrixDumpFormat fmt)
#    #bool dump(FILE *file, const char *var_name,EMatrixDumpFormat fmt = DF_MATLAB_SPARSE)
#
#    #template<typename Scalar> HERMES_API SparseMatrix<Scalar>*  create_matrix(Hermes::MatrixSolverType matrix_solver_type)

