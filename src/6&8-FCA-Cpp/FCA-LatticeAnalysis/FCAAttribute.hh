#ifndef FCAATTRIBUTE_HH_
# define FCAATTRIBUTE_HH_

# include "FCALatticeComponent.hh"

class FCAAttribute : public FCALatticeComponent
{
public :
  FCAAttribute();
  FCAAttribute(int IDAttribute, std::string AttributeName)
    : FCALatticeComponent(IDAttribute, AttributeName)
  {};
  ~FCAAttribute();

  int GetIDAttribute();
  std::string GetNameAttribute();
};

#endif /* !FCAATTRIBUTE_HH_ */
