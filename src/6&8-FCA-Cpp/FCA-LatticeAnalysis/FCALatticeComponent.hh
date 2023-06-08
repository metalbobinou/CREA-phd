#ifndef FCALATTICECOMPONENT_HH_
# define FCALATTICECOMPONENT_HH_

# include <string>

class FCALatticeComponent
{
public :
  FCALatticeComponent();
  FCALatticeComponent(int NewIDComponent, std::string NewComponentName);
  ~FCALatticeComponent();

  int GetID();
  std::string GetName();

protected :
  int IDComponent;
  std::string ComponentName;
};

#endif /* !FCACOMPONENT_HH_ */
