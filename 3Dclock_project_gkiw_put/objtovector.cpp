#include "objtovector.h"

std::vector<MeshObject> loadSeparateObjects(std::string path) {
    std::vector<MeshObject> objects;
    std::vector<float> temp_v, temp_vn, temp_vt;

    std::ifstream file(path);
    if (!file.is_open()) return objects;

    std::string line;
    MeshObject* currentObj = nullptr;

    while (std::getline(file, line)) {
        std::stringstream ss(line);
        std::string prefix;
        ss >> prefix;

        if (prefix == "o") {
            objects.push_back(MeshObject());
            currentObj = &objects.back();
            ss >> currentObj->name;
        }
        else if (prefix == "v") {
            float x, y, z;
            ss >> x >> y >> z;
            temp_v.insert(temp_v.end(), { x, y, z });
        }
        else if (prefix == "vn") {
            float x, y, z;
            ss >> x >> y >> z;
            temp_vn.insert(temp_vn.end(), { x, y, z });
        }
        else if (prefix == "vt") {
            float u, v;
            ss >> u >> v;
            temp_vt.insert(temp_vt.end(), { u, v });
        }
        else if (prefix == "f") {
            if (!currentObj) { // Jeśli brak 'o' w pliku
                objects.push_back(MeshObject());
                currentObj = &objects.back();
                currentObj->name = "default";
            }

            std::string vertexData;
            for (int i = 0; i < 3; ++i) { // Zakładamy trójkąty
                ss >> vertexData;
                int vIdx = -1, tIdx = -1, nIdx = -1;

                // Parsowanie formatu v/t/n
                size_t firstSlash = vertexData.find('/');
                size_t lastSlash = vertexData.find_last_of('/');

                vIdx = std::stoi(vertexData.substr(0, firstSlash)) - 1;
                if (firstSlash != lastSlash) { // Ma normalne
                    nIdx = std::stoi(vertexData.substr(lastSlash + 1)) - 1;
                }
                if (firstSlash + 1 != lastSlash) { // Ma UV
                    tIdx = std::stoi(vertexData.substr(firstSlash + 1, lastSlash - firstSlash - 1)) - 1;
                }

                // Kopiowanie do płaskich tablic (Twoje float*)
                currentObj->vertices.insert(currentObj->vertices.end(),
                    { temp_v[vIdx * 3], temp_v[vIdx * 3 + 1], temp_v[vIdx * 3 + 2], 1.0f });

                if (nIdx >= 0)
                    currentObj->normals.insert(currentObj->normals.end(),
                        { temp_vn[nIdx * 3], temp_vn[nIdx * 3 + 1], temp_vn[nIdx * 3 + 2], 0.0f });
                else
                    currentObj->normals.insert(currentObj->normals.end(), { 0,0,0,0 });

                if (tIdx >= 0)
                    currentObj->texcoords.insert(currentObj->texcoords.end(),
                        { temp_vt[tIdx * 2], temp_vt[tIdx * 2 + 1] });
                else
                    currentObj->texcoords.insert(currentObj->texcoords.end(), { 0,0 });

                currentObj->vertexCount++;
            }
        }
    }
    return objects;
}