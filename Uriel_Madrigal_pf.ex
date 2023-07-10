# Final Progect replicating an inventory system
# that performs operations in a csv files
#
# Uriel Madrigal
# 2022-07-29

defmodule Hw do

  @doc """
  Function that storages the list
  of user that can be used to
  access the system
  """
  def users_list() do
    ["admin","urielsm","josepf"]
  end


  @doc """
  Function that storages the list
  of passwords that can be used to
  access the system
  """
  def passwds_list() do
    ["GdlMx22", "1234", "Gato2022"]
  end


  @doc """
  Main function of the program that when
  is being called you can select the action to
  perform in the system
  """
  def main_file(input_file, output_file) do
    main()
    data_set = read_contents(input_file)
    IO.puts("1. Show all the materials of the file")
    IO.puts("2. Show the records availabe to update the file")
    IO.puts("3. Insert a new record manually")
    IO.puts("4. Insert new records available automatically")
    IO.puts("5. Search for an specific material")
    IO.puts("6. Update a specific record")
    IO.puts("7. Remove specified records")
    option1 = IO.gets("Enter the number of option to be performed: ") |> String.trim()
    cond do
       option1 === "1" -> read_contents(input_file)
       option1 === "2" -> insert_records()
       option1 === "3" -> insert_data_manually(output_file, data_set)
       option1 === "4" -> insert_data_auto(output_file, data_set)
       option1 === "5" -> modify_data(data_set)
       option1 === "6" -> modify_data2(output_file, data_set)
       option1 === "7" -> remove_data(output_file, data_set)
    end
  end

  @doc """
  Function that searchs for a specific
  material in the input file, so you can
  check all its details
  """
  def search1(line, search_value) do
    #[new_id, new_material, new_descp, new_qty, new_price, new_date] = line
    if Enum.at(line, 0) === search_value do
      waterline = IO.puts(Enum.join(["Id: ", Enum.at(line, 0), ", Material: ", Enum.at(line, 1), ", Description: ", Enum.at(line, 2), ", Quantity: ", Enum.at(line, 3), ", Price: ", Enum.at(line, 4), ", Date: ", Enum.at(line, 5)], " "))
      waterline
    end
  end


  @doc """
  Function reads the file and
  decode it into a list of lists
  with the content of each
  row of the file
  """
  def read_contents(input_file) do
    input_file
      |> File.stream!
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&String.split(&1, ","))
  end


  @doc """
  Auxiliar function to update a specific
  record of the input file and store the new records
  in a new output file
  """
  def modify_data2(output_file, data_set) do
    search_value = IO.gets("Enter id of the material you want to update: ") |> String.trim()
    data_set
      |> Enum.map(&update_data(&1,search_value))
    store_csv(output_file, data_set)
  end

  @doc """
  Function that based in the id
  of the material recived, modify
  the propierties most frecuently
  modified as: Quantity, price or date
  """
  def update_data(line, search_value) do
    if Enum.at(line, 0) === search_value do
      new_id = search_value
      new_material = Enum.at(line, 1)
      new_descp = Enum.at(line, 2)
      new_qty = IO.gets("Enter de new quantity: ") |> String.trim()
      new_price = IO.gets("Enter the new price: ") |> String.trim()
      new_date = IO.gets("Enter the new date: ") |> String.trim()
      line = [new_id, new_material, new_descp, new_qty, new_price, new_date]
    else
      new_id = Enum.at(line, 0)
      new_material = Enum.at(line, 1)
      new_descp = Enum.at(line, 2)
      new_qty = Enum.at(line, 3)
      new_price = Enum.at(line, 4)
      new_date = Enum.at(line, 5)
      line = [new_id, new_material, new_descp, new_qty, new_price, new_date]
    end
  end


  @doc """
  Auxiliary function to search for
  an specific material  based in the
  id of the material
  """
  def modify_data(data_set) do
    search_value = IO.gets("Enter id of the material you want to display: ") |> String.trim()
    data_set
      |> Enum.map(&search1(&1,search_value))
  end


  @doc """
  Function that insert new records already available
  in the systme in the current records of the input file
  and produces an output file with the new records added
  """
  def insert_data_auto(output_file, dataset) do
    final_data = dataset
    final_data = [ final_data | Enum.map(insert_records(), &(&1))]
    store_csv(output_file, final_data)
  end


  @doc """
  Function that insert a new record manually in the
  already existing records and produces an output file
  with the new record added
  """
  def insert_data_manually(output_file, dataset) do
    final_data = dataset
    new_id = IO.gets("Enter the id of the new material: ") |> String.trim()
    new_material = IO.gets("Enter the name of the material: ") |> String.trim()
    new_descp = IO.gets("Enter the description of the material: ") |> String.trim()
    new_qty = IO.gets("Enter qty: ") |> String.trim()
    new_price = IO.gets("Enter price: ") |> String.trim()
    new_date = IO.gets("Enter date: ") |> String.trim()
    final_data = final_data ++ [[new_id, new_material, new_descp, new_qty, new_price, new_date]]
    store_csv(output_file, final_data)
  end

  @doc """
  Function that write the new data in the
  output file
  """
  def store_csv(output_file, data_set) do
    final_data = data_set
      |> Enum.map(&Enum.join(&1, ","))
      |> Enum.join("\n")
    File.write(output_file, final_data)
  end

  @doc """
  Function that storages the records already available
  in the system to be added to the current records
  """
  def insert_records() do
    new_records = [[0, "Tornillo percutor", "Tornillo para madera 10 mm X 1-1/2", 10, 5, "22/07/2022"],
    [1, "Martillo", "Martillo de acero 11oz", 26, 65,"10/07/2022"],
    [2, "Llave inglesa", "Llave de acero inoxidabes 13'", 3, 40, "15/06/2022"],
    [3, "Broca HSS", "Broca HSS 15/64'' WF0218 Wolfox", 80, 17,  "01/07/2022"],
    [4, "Cadena galvanizada", "Cadena galvanizada 5/16 TC1109 Toolcraft", 50, 87, "18/07/2022"],
    [5, "Almbre de puas", "Alambre de púas 367 m Montana TC2495 Toolcraft", 17, 61, "23/07/2022"]]
    new_records
  end

  @doc """
  Function that storages the records to be
  removed from the existing ones
  """
  def delete_records() do
    new_records = [[12,"Tornillo Percutor", "Tornillo de acero",10,70,25,"22/07/2022"],
    [13,"Martillo", "Martillo rojo",7,85,"23/07/2023"]]
    new_records
  end


  @doc """
  Function that removes specified records from
  the original ones
  """
  def remove_data(output_file, dataset) do
    new_data = Enum.into(dataset, []) -- Enum.into(delete_records, [])
    store_csv(output_file, new_data)
  end


  @doc """
  Part of the main function of the
  program to simulate a login page
  for security reasons
  """
  def main() do
    user = IO.gets("Enter your username: ") |> String.trim()
    password = IO.gets("Enter your password: ") |> String.trim()
      if Enum.member?(users_list, user) do
        if Enum.member?(passwds_list, password) do
          IO.puts("Entered correctly! :)")
          IO.puts("Hello to the Inventory System!")
        else
          IO.puts("Incorrect password!")
        end
      else
        IO.puts("Incorrect username! ")
      end
  end

end
