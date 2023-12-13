class Obsticle {
  PVector A, B, C, D;
  
  Obsticle(PVector A, PVector B, PVector C, PVector D) {
    this.A = A;
    this.B = B;
    this.C = C;
    this.D = D;
    //middle = PVector.div(PVector.add(A, C), 2);
  }
  
  void show() {
    quad(A.x, A.y, B.x, B.y, C.x, C.y, D.x, D.y);
  }
  
  boolean isInside(PVector loc) {
    PVector M = loc;
    return (0 < PVector.sub(M, A).dot(PVector.sub(B, A)) 
        && PVector.sub(M, A).dot(PVector.sub(B, A)) < PVector.sub(B, A).dot(PVector.sub(B, A)))
        && (0 < PVector.sub(M, A).dot(PVector.sub(D, A)) 
        && PVector.sub(M, A).dot(PVector.sub(D, A)) < PVector.sub(D, A).dot(PVector.sub(D, A))); 
  }
}
