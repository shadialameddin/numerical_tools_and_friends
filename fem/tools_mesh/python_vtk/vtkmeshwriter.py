import Discretization.Mesh

import Geometry.Projector

import numpy

class VTKMeshWriter:

    def __init__(self,mesh,filename,degree):
        self.theMesh=mesh
        self.theFilename=filename
        self.theDegree=degree

    def run(self):

        print "Exporting mesh to file \""+self.theFilename+"\""

        oldDegreeGauss=self.theMesh.theDegreeGauss

        self.theStream=open(self.theFilename,'w')


        p=self.theDegree
        nOfElements=self.theMesh.theElementsX.shape[0]

        self.theMesh.theMasterElementX=\
            self.theMesh.theMasterElementX.computeMasterElement(\
                self.theMesh.theDegreeX,\
                self.theDegree)

        self.theMesh.theMasterElementU=\
            self.theMesh.theMasterElementU.computeMasterElement(\
                self.theMesh.theDegreeU,\
                self.theDegree)

        self.writeHead(nOfElements)
        self.writeNodeData()

        if self.theMesh.theParametricDimension==2:
            self.writeCellData(p*p)
            self.writeFaces()
        elif self.theMesh.theParametricDimension==3:
            self.writeCellData(p*p*p)
            self.writeCells()

        self.writeTail()
        self.theStream.close()

        self.theMesh.theMasterElementX=\
                    self.theMesh.theMasterElementX.computeMasterElement(\
                        self.theMesh.theDegreeX,\
                        oldDegreeGauss)

        self.theMesh.theMasterElementU=\
                    self.theMesh.theMasterElementU.computeMasterElement(\
                        self.theMesh.theDegreeU,\
                        oldDegreeGauss)

        print "Done!"

    def writeFaces(self):

        p=self.theDegree
        nOfElements=self.theMesh.theElementsX.shape[0]

        self.theStream.write("<Points>\n")
        self.theStream.write("<DataArray type=\"Float32\" NumberOfComponents=\"3\" format=\"ascii\">\n")

        for iElement in xrange(0,nOfElements):
            xElement=self.theMesh.getXElement(iElement)
            if(self.theMesh.theDimension==2):
                xElement=numpy.concatenate((xElement,numpy.zeros(((p+1)**2,1))),axis=1)
            xElement.tofile(self.theStream,sep=" ")
            self.theStream.write("\n")

        self.theStream.write("</DataArray>\n")
        self.theStream.write("</Points>\n")

        self.writeCellsFaces(nOfElements)

    def writeCells(self):

        p=self.theDegree
        nOfElements=self.theMesh.theElementsX.shape[0]

        self.theStream.write("<Points>\n")
        self.theStream.write("<DataArray type=\"Float32\" NumberOfComponents=\"3\" format=\"ascii\">\n")

        for iElement in xrange(0,nOfElements):
            xElement=self.theMesh.getXElement(iElement)
            xElement.tofile(self.theStream,sep=" ")
            self.theStream.write("\n")

        self.theStream.write("</DataArray>\n")
        self.theStream.write("</Points>\n")

        self.writeCellsCells(nOfElements)

    def writeHead(self, nOfElements):

        p=self.theDegree

        self.theStream.write("<?xml version=\"1.0\"?>\n")
        self.theStream.write(
            "<VTKFile type=\"UnstructuredGrid\" version=\"0.1\" byte_order=\"LittleEndian\">\n")
        self.theStream.write("<UnstructuredGrid>\n")
        self.theStream.write("<Piece NumberOfPoints=\"" + str(
            nOfElements * (p + 1) ** self.theMesh.theParametricDimension) + "\" NumberOfCells=\"" + str(
            nOfElements * p ** self.theMesh.theParametricDimension) + "\">\n")

    def writeTail(self):
        self.theStream.write("</Piece>\n")
        self.theStream.write("</UnstructuredGrid>\n")
        self.theStream.write("</VTKFile>\n")

    def writeCellsFaces(self, nOfElements):

        p=self.theDegree

        nOfSubElements = self.theDegree
        localT = numpy.empty((nOfSubElements, nOfSubElements, 4), dtype=int)
        for iSubElement in xrange(0, nOfSubElements):
            for jSubElement in xrange(0, nOfSubElements):
                localT[
                    iSubElement, jSubElement, 0] =\
                        iSubElement + jSubElement * (nOfSubElements + 1)
                localT[
                    iSubElement, jSubElement, 1] =\
                        iSubElement + 1 + jSubElement * (nOfSubElements + 1)
                localT[iSubElement, jSubElement, 2] =\
                        iSubElement + 1+ (jSubElement + 1) * (nOfSubElements + 1)

                localT[iSubElement, jSubElement, 3] =\
                        iSubElement + (jSubElement + 1) * (nOfSubElements + 1)

        localT = localT.reshape((nOfSubElements ** 2), 4)
        self.theStream.write("<Cells>\n")
        self.theStream.write(
            "<DataArray type=\"Int32\" Name=\"connectivity\" format=\"ascii\">\n")
        for iElement in xrange(0, nOfElements):
            (localT + iElement * (nOfSubElements + 1) ** 2).tofile(
                self.theStream, sep=" ")
            self.theStream.write("\n")
        self.theStream.write("</DataArray>\n")
        self.theStream.write(
            "<DataArray type=\"Int32\" Name=\"offsets\" format=\"ascii\">\n")
        (numpy.arange(1, nOfElements * p * p + 1) * 4).tofile(
            self.theStream, sep=" ")
        self.theStream.write("</DataArray>\n")
        self.theStream.write(
            "<DataArray type=\"Int32\" Name=\"types\" format=\"ascii\">\n")
        (numpy.ones(nOfElements * p * p, dtype=int) * 9).tofile(
            self.theStream, sep=" ")
        self.theStream.write("</DataArray>\n")
        self.theStream.write("</Cells>\n")

    def writeCellsCells(self,nOfElements):

        p=self.theDegree

        nOfSubElements = self.theDegree
        localT = numpy.empty((nOfSubElements, nOfSubElements, nOfSubElements, 8), dtype=int)
        for iSubElement in xrange(0, nOfSubElements):
            for jSubElement in xrange(0, nOfSubElements):
                for kSubElement in xrange(0, nOfSubElements):
                    localT[
                        iSubElement, jSubElement, kSubElement, 0] =\
                            iSubElement+\
                            jSubElement*(nOfSubElements + 1)+\
                            kSubElement*(nOfSubElements + 1)*(nOfSubElements + 1)
                    localT[
                        iSubElement, jSubElement, kSubElement, 1] =\
                            iSubElement + 1+\
                            jSubElement * (nOfSubElements + 1)+\
                             kSubElement*(nOfSubElements + 1)*(nOfSubElements + 1)

                    localT[iSubElement, jSubElement, kSubElement, 2] =\
                            iSubElement + 1+\
                            (jSubElement + 1) * (nOfSubElements + 1)+\
                            kSubElement*(nOfSubElements + 1)*(nOfSubElements + 1)

                    localT[iSubElement, jSubElement, kSubElement, 3] =\
                            iSubElement +\
                            (jSubElement + 1) * (nOfSubElements + 1)+\
                            kSubElement*(nOfSubElements + 1)*(nOfSubElements + 1)

                    localT[
                        iSubElement, jSubElement, kSubElement, 4] =\
                            iSubElement+\
                            jSubElement*(nOfSubElements + 1)+\
                            (kSubElement+1)*(nOfSubElements + 1)*(nOfSubElements + 1)
                    localT[
                        iSubElement, jSubElement, kSubElement, 5] =\
                            iSubElement + 1+\
                            jSubElement * (nOfSubElements + 1)+\
                            (kSubElement+1)*(nOfSubElements + 1)*(nOfSubElements + 1)

                    localT[iSubElement, jSubElement, kSubElement, 6] =\
                            iSubElement + 1+\
                            (jSubElement + 1) * (nOfSubElements + 1)+\
                            (kSubElement+1)*(nOfSubElements + 1)*(nOfSubElements + 1)

                    localT[iSubElement, jSubElement, kSubElement, 7] =\
                            iSubElement +\
                            (jSubElement + 1) * (nOfSubElements + 1)+\
                            (kSubElement+1)*(nOfSubElements + 1)*(nOfSubElements + 1)

        localT = localT.reshape((nOfSubElements ** 3), 8)

        self.theStream.write("<Cells>\n")
        self.theStream.write(
            "<DataArray type=\"Int32\" Name=\"connectivity\" format=\"ascii\">\n")

        for iElement in xrange(0, nOfElements):
            (localT + iElement * (nOfSubElements + 1) ** 3).tofile(self.theStream, sep=" ")
            self.theStream.write("\n")

        self.theStream.write("</DataArray>\n")

        self.theStream.write(
            "<DataArray type=\"Int32\" Name=\"offsets\" format=\"ascii\">\n")
        (numpy.arange(1, nOfElements * p * p * p + 1) * 8).tofile(
            self.theStream, sep=" ")

        self.theStream.write("</DataArray>\n")
        self.theStream.write(
            "<DataArray type=\"Int32\" Name=\"types\" format=\"ascii\">\n")
        (numpy.ones(nOfElements * p * p * p, dtype=int) * 12).tofile(
            self.theStream, sep=" ")
        self.theStream.write("</DataArray>\n")
        self.theStream.write("</Cells>\n")

    def writeNodeData(self):

        if not self.theMesh.theParameterization==None:

            self.theStream.write("<PointData Scalars=\"scalars\">\n")

            self.theStream.write("<DataArray type=\"Float32\" Name=\"distance\" format=\"ascii\">\n")

            for iElement in xrange(self.theMesh.theNOfElements):

                x=numpy.dot(self.theMesh.theMasterElementX.theShapeFunctionsValue,self.theMesh.theNodes[self.theMesh.theElementsX[iElement,:],:])
                u=self.theMesh.getUElement(iElement)

                projector = Geometry.Projector.Projector(x,self.theMesh.theParameterization)
                u=projector.run(u)

                d=numpy.linalg.norm(x-self.theMesh.theParameterization.value(u),axis=1)

                d.tofile(self.theStream, sep=" ")
                self.theStream.write("\n")

            self.theStream.write("</DataArray>\n")

            self.theStream.write("<DataArray type=\"Float32\" Name=\"uv\" NumberOfComponents=\"2\" format=\"ascii\">\n")

            for iElement in xrange(self.theMesh.theNOfElements):

                u=self.theMesh.getUElement(iElement)

                u.tofile(self.theStream, sep=" ")
                self.theStream.write("\n")


            self.theStream.write("</DataArray>\n")

            self.theStream.write("<DataArray type=\"Float32\" Name=\"phi\" NumberOfComponents=\"3\" format=\"ascii\">\n")

            for iElement in xrange(self.theMesh.theNOfElements):

                u=self.theMesh.getUElement(iElement)

                x=self.theMesh.theParameterization.value(u)

                x.tofile(self.theStream, sep=" ")
                self.theStream.write("\n")

            self.theStream.write("</DataArray>\n")

            self.theStream.write("</PointData>\n")

    def writeCellData(self,nOfSubElements):

        if(len(self.theMesh.theElementalFields)==0):
            return

        self.theStream.write("<CellData>\n")

        for key in self.theMesh.theElementalFields:
            field=self.theMesh.theElementalFields[key]
            self.theStream.write("<DataArray type=\"Float32\" Name=\""+key+"\" NumberOfComponents=\""+str(field.shape[1])+"\" format=\"ascii\">\n")
            for iElement in xrange(self.theMesh.theNOfElements):
                localField=numpy.ones((nOfSubElements,len(field[iElement])))*field[iElement]
                localField.tofile(self.theStream, sep=" ")
                self.theStream.write("\n")
            self.theStream.write("</DataArray>\n")


        self.theStream.write("</CellData>\n")


    theMesh = None
    theFilename = None
    theStream = None
