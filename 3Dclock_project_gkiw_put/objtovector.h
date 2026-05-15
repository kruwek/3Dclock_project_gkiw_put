#ifndef OBJTOVECTOR_H
#define OBJTOVECTOR_H

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>


struct MeshObject {
    std::string name;
    std::vector<float> vertices;  // XYZW
    std::vector<float> normals;   // XYZW (czwarty to 0.0)
    std::vector<float> texcoords; // UV
    int vertexCount = 0;
};

std::vector<MeshObject> loadSeparateObjects(std::string path);

#endif