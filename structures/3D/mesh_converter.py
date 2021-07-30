import sys
import numpy as np
import scipy.io as sio
import os

def convert_mesh_to_mat(file_name):
    with open(file_name, 'r') as input_mesh:
        input_mesh = input_mesh.read().splitlines()
        nr_vertices = int(input_mesh[0])
        vertices = np.zeros(shape=(nr_vertices, 3))
        start = 1
        end = start + nr_vertices
        for i, line in enumerate(input_mesh[start:end], start=0):
            vertices[i, :] = np.asarray(line.strip().split(), dtype=np.float32)
        
        nr_tetrahedra = int(input_mesh[nr_vertices+1])
        start = end + 1
        end = start + nr_tetrahedra
        tetrahedra = np.zeros(shape=(nr_tetrahedra, 4))
        for i, line in enumerate(input_mesh[start:end]):
            tetrahedra[i, :] = np.asarray(line.strip().split()[1:], dtype=int)
        
        nr_surface = int(input_mesh[end])
        start = end + 1
        end = start + nr_surface
        surface = np.zeros(shape=(nr_surface, 3))
        for i, line in enumerate(input_mesh[start:end]):
            surface[i, :] = np.asarray(line.strip().split()[1:], dtype=int)

        free_vertices = np.setdiff1d(np.unique(tetrahedra), np.unique(surface))
        print(vertices)
        print(tetrahedra)
        print(free_vertices)
        print(surface)

        mesh_mat = {"vertices": vertices, "tetrahedra": tetrahedra, "free_vertices": free_vertices, "surface": surface}
        return mesh_mat

def convert_mat_to_mesh(file_name):
    input_mesh = sio.loadmat(file_name)
    output_mesh = ""
    vertices = input_mesh['vertices']
    output_mesh += str(len(vertices)) + "\n"
    for vertex in vertices:
        output_mesh += " ".join(vertex.astype(str)) + "\n"
    
    tetrahedra = input_mesh['tetrahedra']
    output_mesh += str(len(tetrahedra)) + "\n"
    for tet in tetrahedra:
        output_mesh += "1 " + " ".join(tet.astype(int).astype(str)) + "\n"
    
    surface = input_mesh['surface']
    output_mesh += str(len(surface)) + "\n"
    for surf in surface:
        output_mesh += "3 " + " ".join(surf.astype(int).astype(str)) + "\n"

    return output_mesh

def convert_mat_to_vtk(file_name):
    input_mesh = sio.loadmat(file_name)
    output_mesh = ""
    output_mesh += "# vtk DataFile Version 2.0\n"
    output_mesh += "Mesquite Mesh original_mesh .\n"
    output_mesh += "ASCII\n"
    output_mesh += "DATASET UNSTRUCTURED_GRID\n"

    nr_vertices = len(input_mesh['vertices'])

    output_mesh += "POINTS " + str(nr_vertices) + " " + "double\n"

    for vertex in input_mesh['vertices']:
        vertex = ["%.6f" % n for n in vertex]
        output_mesh += " ".join(vertex) + "\n"
    
    
    nr_elements = len(input_mesh['tetrahedra'])
    output_mesh += "CELLS " + str(nr_elements) + " " + str(5*nr_elements) + " \n"

    for el in input_mesh['tetrahedra']:
        el[[1,2]] = el[[2,1]]
        el -= 1
        output_mesh += "4 " + " ".join(el.astype(int).astype(str)) + "\n"
    
    output_mesh += "CELL_TYPES " + str(nr_elements) + "\n"

    output_mesh += "10\n"*nr_elements

    output_mesh += "POINT_DATA " + str(nr_vertices) + "\n"
    output_mesh += "SCALARS fixed int\n"
    output_mesh += "LOOKUP_TABLE default\n"
    
    is_surface = np.ones(shape=(nr_vertices, 1))
    is_surface[(input_mesh['free_vertices'].flatten() - 1).astype(int)] = 0
    # print(input_mesh['free_vertices'])
    # print(is_surface)

    is_surface = np.core.defchararray.add(is_surface.astype(int).astype(str).flat, '\n')
    output_mesh += "".join(is_surface.tolist())
    return output_mesh


def convert_vtk_to_mat(vtk_file):
     with open(vtk_file, 'r') as vtk_mesh:
        
        vtk_mesh = vtk_mesh.read().splitlines()
        for i, line in enumerate(vtk_mesh):
            if line.startswith("POINTS"):
                break
        
        start_vertices = i + 1
        nr_vertices = int(line.split(" ")[1])
        end_vertices = start_vertices + nr_vertices

        np_vertices = np.zeros(shape=(nr_vertices, 3))
        for j, vertex in enumerate(vtk_mesh[start_vertices:end_vertices]):
            vertex = np.fromstring(vertex, dtype=np.float32, sep=' ')
            np_vertices[j, :] = vertex
            
        nr_elements = int(vtk_mesh[end_vertices].split(" ")[1])

        np_elements = np.zeros(shape=(nr_elements, 4))
        start_elements = end_vertices + 1
        end_elements = start_elements + nr_elements
        for i, el in enumerate(vtk_mesh[start_elements:end_elements]):
            el = np.fromstring(el, dtype=int, sep=' ')
            np_elements[i, :] = el[1:]

        # +1 ponieważ indeksowanie w formacie .vtk zaczyna się od 0, a w .mat od 1
        np_elements = np_elements + 1

        start_free_vertices = end_elements + 1 + nr_elements + 1 + 2
        end_free_vertices = start_free_vertices + nr_vertices
        free_vertices = []
        for i, is_fixed in enumerate(vtk_mesh[start_free_vertices:end_free_vertices]):
            if not int(is_fixed):
                free_vertices.append(i + 1)
        
    
        free_vertices = np.asarray(free_vertices)
        surface = []
        # w celu wykrycia trójkątów powierzchniowych trzeba podzielić każdy tet na 4 trójkąty
        # i dla każdego trójkąta sprawdzić czy nie zawiera wolnego wierzchołka
        # jeżeli nie zawiera, to znaczy, że to jest trójkąt powierzchniowy
        for i, surf in enumerate(np_elements):
            triangles = np.asarray([surf[[0,1,2]], surf[[0,1,3]], surf[[1,2,3]], surf[[0, 2, 3]]])
            for tri in triangles:
                vertices_set = np.setdiff1d(tri, free_vertices)
                if len(vertices_set) == 3:
                    surface.append(vertices_set)
            
        surface = np.unique(np.asarray(surface), axis=0)
        mat_data = {"vertices": np_vertices, "tetrahedra": np_elements, "free_vertices": free_vertices, "surface": surface}
        return mat_data


def convert_vtk_to_mesh(file_name):
    output_mesh = convert_vtk_to_mat(file_name)
    sio.savemat("temporary.mat", output_mesh)
    output_mesh = convert_mat_to_mesh("temporary.mat")
    os.remove("temporary.mat")
    return output_mesh

def convert_mesh_to_vtk(file_name):
    output_mesh = convert_mesh_to_mat(file_name)
    sio.savemat("temporary.mat", output_mesh)
    output_mesh = convert_mat_to_vtk("temporary.mat")
    os.remove("temporary.mat")
    return output_mesh


if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit("Please provide input mesh and name of output mesh")
    
    input_mesh_full_name = sys.argv[1]
    output_mesh_full_name = sys.argv[2]
    
    input_mesh_type = input_mesh_full_name[input_mesh_full_name.index('.') + 1:]
    output_mesh_type = output_mesh_full_name[output_mesh_full_name.index('.') + 1:]
    output_mesh_name = output_mesh_full_name[0:output_mesh_full_name.index('.')]

    print("input mesh type: " + input_mesh_type)
    print("output mesh type: " + output_mesh_type)

    if input_mesh_type == 'mesh' and output_mesh_type == 'mat':
        output_mesh = convert_mesh_to_mat(input_mesh_full_name)
        sio.savemat(output_mesh_full_name, output_mesh)

    if input_mesh_type == 'mat' and output_mesh_type == 'mesh':
        output_mesh = convert_mat_to_mesh(input_mesh_full_name)
        with open(output_mesh_full_name, "w") as output_file:
            output_file.write(output_mesh)

    if input_mesh_type == 'vtk' and output_mesh_type == 'mat':
        output_mesh = convert_vtk_to_mat(input_mesh_full_name)
        sio.savemat(output_mesh_full_name, output_mesh)

    if input_mesh_type == 'mat' and output_mesh_type == 'vtk':
        output_mesh = convert_mat_to_vtk(input_mesh_full_name)
        with open(output_mesh_full_name, "w") as output_file:
            output_file.write(output_mesh)
        
    if input_mesh_type == 'vtk' and output_mesh_type == 'mesh':
        output_mesh = convert_vtk_to_mesh(input_mesh_full_name)
        with open(output_mesh_full_name, "w") as output_file:
            output_file.write(output_mesh)

    if input_mesh_type == 'mesh' and output_mesh_type == 'vtk':
        output_mesh = convert_mesh_to_vtk(input_mesh_full_name)
        with open(output_mesh_full_name, "w") as output_file:
            output_file.write(output_mesh)
        