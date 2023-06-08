#ifndef FCAOBJECT_HH_
# define FCAOBJECT_HH_

# include "FCALatticeComponent.hh"

class FCAObject : public FCALatticeComponent
{
public :
  FCAObject();
  FCAObject(int IDObject, std::string ObjectName)
    : FCALatticeComponent(IDObject, ObjectName)
  {};
  ~FCAObject();

  int GetIDObject();
  std::string GetNameObject();
};

#endif /* !FCAOBJECT_HH_ */
