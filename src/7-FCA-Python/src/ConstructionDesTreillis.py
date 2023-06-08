
import glob, os
import sys
import numpy
from concepts import *

def creation_treillis_XML(filename):
   name=filename[:-4]
   f1=open(name+'_treillis.xml','w')
   f1.write('<?xml version="1.0" encoding="UTF-8"?>\n')
   c=Context.fromfile(filename)
   l=c.lattice
   dot=l.graphviz()
   dot.render(name+'.gv')
   f1.write('<LAT type="ConceptLattice" Desc="'+name+' - T.slf - #OfNodes = '+str(len(l))+'">\n')
   f1.write('<OBJS>\n')
   dico_lattice={}
   for i in range(len(l)):
      dico_lattice[l[i]]=i
   dico_obj={}
   dico_att={}
   for i in range(len(c.objects)):
      f1.write('<OBJ id="'+str(i)+'">'+c.objects[i]+'</OBJ>\n')
      dico_obj[c.objects[i]]=i
   f1.write('</OBJS>\n')
   f1.write('<ATTS>\n')
   for i in range(len(c.properties)):
      f1.write('<ATT id="'+str(i)+'">'+c.properties[i]+'</ATT>\n')
      dico_att[c.properties[i]]=i
   f1.write('</ATTS>\n')
   f1.write('<NODS>\n')
   for i in range(len(l)):
      f1.write('<NOD id="'+str(i)+'">\n')
      f1.write('<EXT>\n')
      for j in range(len(l[i].extent)):
         f1.write('<OBJ id="'+str(dico_obj[l[i].extent[j]])+'"/>\n')
      f1.write('</EXT>\n')
      f1.write('<INT>\n')
      for j in range(len(l[i].intent)):
         f1.write('<ATT id="'+str(dico_att[l[i].intent[j]])+'"/>\n')
      f1.write('</INT>\n')
      if(len(l[i].upper_neighbors)==0):
         f1.write('<SUP_NOD/>\n')
      else:
         f1.write('<SUP_NOD>\n')
         for j in range(len(l[i].upper_neighbors)):
            f1.write('<PARENT id="'+str(dico_lattice[l[i].upper_neighbors[j]])+'"/>\n')
         f1.write('</SUP_NOD>\n')
      f1.write('</NOD>\n')
   f1.write('</NODS>\n')
   f1.write('</LAT>\n')
   f1.close()


os.chdir("./FichiersStrategies")
for file in glob.glob("*.txt"):
   try:
      creation_treillis_XML(file)
      print(file)
   except Exception as eee :
      print(" Error creation_treillis_XML ", eee)
