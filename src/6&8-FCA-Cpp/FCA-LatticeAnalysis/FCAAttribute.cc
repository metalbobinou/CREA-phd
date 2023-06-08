#include "FCAAttribute.hh"

FCAAttribute::FCAAttribute()
{
}

FCAAttribute::~FCAAttribute()
{
}

int FCAAttribute::GetIDAttribute()
{
  return(this->GetID());
}

std::string FCAAttribute::GetNameAttribute()
{
  return (this->GetName());
}
