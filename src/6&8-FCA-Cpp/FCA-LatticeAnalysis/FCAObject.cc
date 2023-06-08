#include "FCAObject.hh"

FCAObject::FCAObject()
{
}

FCAObject::~FCAObject()
{
}

int FCAObject::GetIDObject()
{
  return(this->GetID());
}

std::string FCAObject::GetNameObject()
{
  return (this->GetName());
}
