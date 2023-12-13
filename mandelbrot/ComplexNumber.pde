class ComplexNumber {
  double real, imag;
  
  ComplexNumber(double real, double imag) {
    this.real = real;
    this.imag = imag;
  }
  
  ComplexNumber mult(ComplexNumber n) {
    return new ComplexNumber(real*n.real - imag*n.imag, real*n.imag + imag*n.real);
  }
  
  ComplexNumber add(ComplexNumber n) {
    return new ComplexNumber(real+n.real, imag+n.imag);
  }
  
  double absSquared() {
    return real*real + imag*imag;
  }
}
