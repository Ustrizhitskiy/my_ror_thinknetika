class Interface
  attr_reader :all_stations, :all_trains, :all_routes, :cargo_trains,
    :passenger_trains, :count, :selected_route, :get_route_number, :a

  def initialize
    @all_stations = []
    @all_trains = []
    @cargo_trains = []
    @passenger_trains = []
    @all_routes = []
  end

  def menu
    puts "Добро пожаловать."
    puts "Для выбора действия, введите его номер:"
    puts "1.  Создать станцию."
    puts "2.  Создать поезд."
    puts "3.  Создать маршрут."
    puts "4.  Добавить станцию в маршрут."
    puts "5.  Удалить станцию из маршрута."
    puts "6.  Назначить маршрут поезду."
    puts "7.  Добавить вагон к поезду."
    puts "8.  Отцепить вагон от поезда."
    puts "9.  Отправить поезд на следующую по маршруту станцию."
    puts "10. Отправить поезд на предыдущую по маршруту станцию."
    puts "11. Просмотреть список станций."
    puts "12. Просмотреть список поездов, находящихся на станции."
    puts "13. Просмотреть все маршруты."
    puts "0.  Выйти из программы."
  end

  def choose
    loop do
      menu
      count = gets.to_i
      case count
      when 1
        create_new_station
      when 2
        create_new_train
      when 3
        create_new_route
      when 4
        add_station_to_route
      when 5
        delete_station_from_route
      when 6
        add_route_to_train
      when 7
        add_wagon_to_train
      when 8
        delete_wagon_from_train
      when 9
        move_next_station
      when 10
        move_previos_station
      when 11
        all_stations
      when 12
        show_all_trains
      when 13
        show_all_routes
      when 0
        abort
      end
    end
  end

  def return_to_menu
    puts "Для возврата в меню нажмите ENTER"
    gets
  end

  def  create_new_station
    puts "Введите название станции:"
    name = gets.chomp.to_s
    @all_stations << Station.new(name)
    puts "Вы создали станцию #{name}"
    return_to_menu
  end

  def create_new_train
    puts "Какой поезд (пассажирский или грузовой) хотите создать?"
    puts "1. Грузовой."
    puts "2. Пассажирский."
    type_wagon = gets.chomp.to_i
    case type_wagon
    when 1
      print "Введите номер или название поезда: "
      number = gets.chomp.to_s
      cargo_train = CargoTrain.new(number)
      @cargo_trains << cargo_train
      @all_trains << cargo_train
      puts "Вы создали поезд:"
      puts "#Номер: #{number}\nТип: #{cargo_train.type}"
      return_to_menu
    when 2
      print "Введите номер или название поезда: "
      number = gets.chomp.to_s
      passenger_train = PassengerTrain.new(number)
      @passenger_trains << passenger_train
      @all_trains << passenger_train
      puts "Вы создали поезд:"
      puts "#Номер: #{number}\nТип: #{passenger_train.type}"
    end
  end

  def create_new_route
    if create_possible?
      create_new_route!
    else 
      puts "Для создания маршрута необхобимо минимум две станции. Создайте их."
      return_to_menu
    end
  end

  def create_possible?
    @all_stations.size >= 2
  end

  def create_new_route!
    print "Введите номер маршрута: "
    number = gets.chomp.to_i
    puts "Выберете начальную станцию (введите номер) из имеющихся:"
    show_all_stations
    start_input = gets.chomp.to_i
    start_station = ''
    @all_stations.each.with_index(1) { |station, index|
      start_station = station.name if start_input == index }

    stations_without_start_stations = @all_stations.select { |station|
      station.name != start_station }
    puts "Выберете конечную станцию (введите номер) из предложенных:"
    stations_without_start_stations.each.with_index(1) { |station, index|
      puts "#{index}. #{station.name}"}

    finish_input = gets.chomp.to_i
    finish_station = ''
    stations_without_start_stations.each.with_index(1) { |station, index|
      finish_station = station.name if finish_input == index }

    route = Route.new(number, start_station, finish_station)
    puts "Вы создали маршрут:"
    puts "Номер маршрута: #{number}\nНачальная станция: #{start_station}\n
      Конечная станция: #{finish_station}"
    return_to_menu

    @all_routes << route
  end

  def add_station_to_route
    show_all_routes
    print "Введите номер маршрута, в который хотите добавить станцию: "
    add_station_to_route! if is_there_route? != -1
    return_to_menu
  end

  def is_there_route?
    @a = - 1
    @get_route_number = gets.chomp.to_i
    @all_routes.each.with_index { |route, index|
      if route.route_number == @get_route_number
        @count = index
        @a = index
        @selected_route = route
      end }

      if @a == -1
        puts "Такого маршрута не существует. Попробуйте создать." 
      end
      return @a
  end

  def add_station_to_route!
        @all_routes.delete_at(@count)
        @selected_route.all_stations_of_route
        print "На какое по порядку место хотите добавить станцию? "
        number = gets.chomp.to_i
    
        puts "Какую станцию хотите добавить (введите номер из списка) из имеющихся:"
        available_stations = []
        @all_stations.each { |station|
          if !@selected_route.route_stations.include?(station.name)
            available_stations << station
          end }
        puts "Все существующие станции уже добавлены. 
        Создайте новую станцию." if available_stations == 0
        available_stations.each.with_index(1) { |station, index|
          puts "#{index}. #{station.name}" }

        place = gets.chomp.to_i
        station = available_stations[place - 1]

        @selected_route.route_stations.insert(number - 1, station.name)
        @all_routes.insert(@count, @selected_route)
        puts "Вы изменили маршрут №_#{@get_route_number}."
        @selected_route.all_stations_of_route
        return_to_menu
  end

  def delete_station_from_route
    show_all_routes
    print "Введите номер маршрута, из которого хотите удалить станцию: "
    delete_station_from_route! if is_there_route? != -1
    return_to_menu
  end

  def delete_station_from_route!
    @all_routes.delete_at(@count)
    @selected_route.all_stations_of_route
    puts "Какую станцию хотите удалить (введите номер из списка): "
    number = gets.chomp.to_i
    @selected_route.route_stations.each.with_index(0) { |station, index|
      @selected_route.route_stations.delete_at(number) if number == index }

    @all_routes.insert(@count, @selected_route)
    puts "Вы изменили маршрут №_#{@get_route_number}."
    @selected_route.all_stations_of_route
    return_to_menu
  end

  def add_route_to_train
    show_all_routes
    print "Введите номер маршрута, который собираетесь назначить: "
    if is_there_route? != -1
      show_all_trains
      train = train_choice
      train.set_route(@selected_route)
    end
    return_to_menu
  end

  def add_wagon_to_train
    show_all_trains
    train = train_choice
    if train.type == :Cargo
      wagon = CargoWagon.new
      train.add_wagon(wagon)
    else
      wagon = PassengerWagon.new
      train.add_wagon(wagon)
    end

    puts "Номер: #{train.number}, вагонов: #{train.wagons.size}, тип - #{train.type}"
    return_to_menu
  end

  def delete_wagon_from_train
    show_all_trains
    train = train_choice
    train.delete_wagon
    puts "Номер: #{train.number}, вагонов: #{train.wagons.size}, тип - #{train.type}"
    return_to_menu
  end  

  def move_next_station
    train = train_choice
    train.go_to_next_station
  end

  def move_previos_station
    train = train_choice
    train.go_to_previos_station
  end

  def show_all_stations
    @all_stations.each.with_index(1) { |station, index|
      puts "#{index}. #{station.name}" }
  end

  def all_stations
    puts "Список всех созданных станций:"
    show_all_stations
    return_to_menu
  end

  def show_all_routes
    @all_routes.each { |route_stations|
      route_stations.all_stations_of_route }
  end

  def show_all_trains
    @all_trains.each.with_index(1) { |train, index|
      puts "#{index} | #{train.number} - #{train.type}" }
  end

  def train_choice
    print 'Выберите поезд (введите порядковый номер) из списка: '
    number = gets.chomp.to_i
    train = @all_trains[number - 1]
  end

end
