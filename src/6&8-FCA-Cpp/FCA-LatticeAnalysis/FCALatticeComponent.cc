#include "FCALatticeComponent.hh"

FCALatticeComponent::FCALatticeComponent()
{
}

FCALatticeComponent::FCALatticeComponent(int NewIDComponent,
					 std::string NewComponentName)
{
  this->IDComponent = NewIDComponent;
  this->ComponentName = NewComponentName;
}

FCALatticeComponent::~FCALatticeComponent()
{
}

int FCALatticeComponent::GetID()
{
  return (this->IDComponent);
}

std::string FCALatticeComponent::GetName()
{
  return (this->ComponentName);
}
