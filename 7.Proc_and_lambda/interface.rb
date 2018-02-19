class Interface
  include Validation

  attr_reader :all_stations, :all_trains, :all_routes, :cargo_trains,
    :passenger_trains, :count, :selected_route, :get_route_number, :a

  def initialize
    @all_stations = []
    @all_trains = []
    @cargo_trains = []
    @passenger_trains = []
    @all_routes = []
  end

  puts 'Добро пожаловать.'

  def menu
    puts %(Для выбора действия, введите его номер:
    1.  Создать станцию.
    2.  Создать поезд.
    3.  Создать маршрут.
    4.  Добавить станцию в маршрут.
    5.  Удалить станцию из маршрута.
    6.  Назначить маршрут поезду.
    7.  Добавить вагон к поезду.
    8.  Отцепить вагон от поезда.
    9.  Отправить поезд на следующую по маршруту станцию.
    10. Отправить поезд на предыдущую по маршруту станцию.
    11. Просмотреть список станций.
    12  Просмотреть все созданные поезда.
    13. Просмотреть список поездов, находящихся на станции.
    14. Найти поезд по номеру (названию).
    15. Просмотреть все маршруты.
    16. Просмотреть состояние всех вагонов в поезде.
    17. Занять место (объем) в вагоне.
    0.  Выйти из программы.)
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
        puts "\nВсего создано #{Station.instances} станций."
        all_stations
      when 12
        puts "\nВсего создано #{[CargoTrain.instances, PassengerTrain.instances].compact.inject(&:+)} поездов."
        show_all_trains
        return_to_menu
      when 13
        show_all_trains_on_station
      when 14
        finding_train
        return_to_menu
      when 15
        puts "\nВсего создано #{Route.instances} маршрутов."
        show_all_routes
        return_to_menu
      when 16
        show_wagons_of_train
        return_to_menu
      when 17
        take_some_space_in_wagon
        return_to_menu
      when 0
        abort
      end
    end
  end

  def return_to_menu
    puts 'Для возврата в меню нажмите ENTER'
    gets
  end

  def  create_new_station
    puts 'Введите название станции:'
    name = gets.chomp.to_s
    @all_stations << Station.new(name)
    puts "Вы создали станцию #{name}"
    return_to_menu
  end

  def create_new_train
    begin
      puts 'Какой поезд (пассажирский или грузовой) хотите создать?'
      puts '1. Грузовой.'
      puts '2. Пассажирсий.'
      puts 'Введите любой другой символ и нажмите ENTER для возврата в меню...'

      type_wagon = gets.chomp.to_i

      case type_wagon
        when 1
          print 'Введите номер или название поезда в формате ххх-хх или ххххх: '
          number = gets.chomp.to_s
          print 'Введите производителя: '
          manufacturer = gets.chomp.to_s
          train = CargoTrain.new(number, manufacturer)
          @cargo_trains << train
          @all_trains << train
          puts "\nВы создали поезд:"
          puts "Номер: #{number}\nПроизводитель: #{manufacturer}\nТип: грузовой\n"
          add_train_to_station?(train)
        when 2
          print 'Введите номер или название поезда в формате ххх-хх или ххххх: '
          number = gets.chomp.to_s
          print 'Введите производителя: '
          manufacturer = gets.chomp.to_s
          train = PassengerTrain.new(number, manufacturer)
          @passenger_trains << train
          @all_trains << train
          puts "\nВы создали поезд:"
          puts "Номер: #{number}\nПроизводитель: #{manufacturer}\nТип: пассажирский\n"
          add_train_to_station?(train)
      end

      rescue RuntimeError => e
        puts e.message
        puts "Попробуйте еще раз.\n"
      retry
    end
  end

  def add_train_to_station?(train)
    print "Добавить поезд на станцию ('Y'/'N')? "
    yes_no = gets.chomp.to_s
    if ['y', 'Y'].include?(yes_no)
      choose_station_to_add_train(train)
    else
      puts 'Позже это все равно надо будет сделать.'
    end
  end

  def choose_station_to_add_train(train)
    show_all_stations
    print 'На какую станцию добавить поезд (выберете номер из списка)? '
    number = gets.to_i
    @all_stations.each.with_index(1) do |station, index|
      station.parking_trains(train) if number == index
    end

    puts "Вы добавили поезд №_#{train.number} на станцию #{@all_stations[number - 1].name}."
    return_to_menu
  end

  def create_new_route
    if create_possible?
      create_new_route!
    else 
      puts 'Для создания маршрута необхобимо минимум две станции. Создайте их.'
      return_to_menu
    end
  end

  def create_possible?
    @all_stations.size >= 2
  end

  def create_new_route!
    print "Введите номер маршрута: "
    number = gets.to_i
    puts 'Выберете начальную станцию (введите номер) из имеющихся:'
    show_all_stations
    start_input = gets.to_i
    start_station = ''
    @all_stations.each.with_index(1) do |station, index|
      start_station = station if start_input == index
    end

    stations_without_start_stations = @all_stations.reject do |station|
      station == start_station
    end
    puts 'Выберете конечную станцию (введите номер) из предложенных:'
    stations_without_start_stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end

    finish_input = gets.chomp.to_i
    finish_station = ''
    stations_without_start_stations.each.with_index(1) do |station, index|
      finish_station = station if finish_input == index
    end

    route = Route.new(number, start_station, finish_station)
    puts 'Вы создали маршрут:'
    puts %{Номер маршрута: #{number}\nНачальная станция: #{start_station.name}
      \rКонечная станция: #{finish_station.name}}
    return_to_menu

    @all_routes << route
  end

  def add_station_to_route
    show_all_routes
    print 'Введите номер маршрута, в который хотите добавить станцию: '
    add_station_to_route! if is_there_route? != -1
    return_to_menu
  end

  def is_there_route?
    @a = - 1
    @get_route_number = gets.chomp.to_i
    @all_routes.each.with_index do |route, index|
      if route.route_number == @get_route_number
        @count = index
        @a = index
        @selected_route = route
      end
    end

      puts 'Такого маршрута не существует. Попробуйте создать.' if @a == -1

      return @a
  end

  def add_station_to_route!
    @all_routes.delete_at(@count)
    @selected_route.all_stations_of_route
    print 'На какое по порядку место хотите добавить станцию? '
    number = gets.chomp.to_i
    
    puts 'Какую станцию хотите добавить (введите номер из списка) из имеющихся:'
    available_stations = []
    @all_stations.each do |station|
      if !@selected_route.route_stations.include?(station.name)
        available_stations << station
      end
    end
    puts 'Все существующие станции уже добавлены. 
    Создайте новую станцию.' if available_stations.size == 0
    available_stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end

    place = gets.chomp.to_i
    station = available_stations[place - 1]

    @selected_route.route_stations.insert(number - 1, station)
    @all_routes.insert(@count, @selected_route)
    puts "Вы изменили маршрут №_#{@get_route_number}."
    @selected_route.all_stations_of_route
  end

  def delete_station_from_route
    show_all_routes
    print 'Введите номер маршрута, из которого хотите удалить станцию: '
    delete_station_from_route! if is_there_route? != -1
    return_to_menu
  end

  def delete_station_from_route!
    @all_routes.delete_at(@count)
    @selected_route.all_stations_of_route
    puts 'Какую станцию хотите удалить (введите номер из списка): '
    number = gets.chomp.to_i
    @selected_route.route_stations.delete_at(number - 1)

    @all_routes.insert(@count, @selected_route)
    puts "Вы изменили маршрут №_#{@get_route_number}."
    @selected_route.all_stations_of_route
  end

  def add_route_to_train
    show_all_routes
    print 'Введите номер маршрута, который собираетесь назначить: '
    if is_there_route? != -1
      puts
      show_all_trains
      train = train_choice
      train.set_route(@selected_route)
    end
    return_to_menu
  end

  def add_wagon_to_train
    show_all_trains
    train = train_choice
    if train.class == CargoTrain
      print 'Введите производителя вагона: '
      manufacturer = gets.to_s
      print 'Введите объем вагона: '
      total_volume = gets.to_i
      wagon = CargoWagon.new(manufacturer, total_volume)
      train.add_wagon(wagon)
    else
      print 'Введите производителя вагона: '
      manufacturer = gets.to_s
      print 'Введите количество мест в вагоне: '
      all_seats = gets.to_i
      wagon = PassengerWagon.new(manufacturer, all_seats)
      train.add_wagon(wagon)
    end
    puts "\nВы добавили вагон."
    puts "Номер поезда: #{train.number}, вагонов: #{train.wagons.size}, тип - #{train.class}"
    return_to_menu
  end

  def delete_wagon_from_train
    show_all_trains
    train = train_choice
    train.delete_wagon
    puts "\nВы удалали вагон."
    puts "Номер поезда: #{train.number}, вагонов: #{train.wagons.size}, тип - #{train.class}"
    return_to_menu
  end  

  def move_next_station
    show_all_trains
    train = train_choice
    train.go_to_next_station
  end

  def move_previos_station
    show_all_trains
    train = train_choice
    train.go_to_previos_station
  end

  def show_all_stations
    Station.all_instances.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def all_stations
    puts 'Список всех созданных станций:'
    show_all_stations
    return_to_menu
  end

  def show_all_routes
    @all_routes.each do |route_stations|
      route_stations.all_stations_of_route
    end
  end

  def show_all_trains
    @all_trains.each.with_index(1) do |train, index|
      puts "#{index} | Номер (название): #{train.number}; вагонов: #{train.wagons.size}; тип - #{train.class}"
    end
  end

  def show_all_trains_on_station
    show_all_stations
    print 'Введите станцию (выберете номер из списка): '
    number = gets.to_i

    if @all_stations.size > 0
      station = @all_stations[number - 1]
      station.each_train_on_station { |train, index|
        puts "#{index}  |  Номер (название): #{train.number}; тип: #{train.class}; вагонов: #{train.wagons.size}" }
    else
      puts 'Не создано ни одной станции!'
    end

    return_to_menu
  end

  def train_choice
    print 'Выберите поезд (введите порядковый номер) из списка: '
    number = gets.chomp.to_i
    train = @all_trains[number - 1]
  end

  def finding_train
    puts 'Введите номер (название) поезда, о котором хотите получить информацию: '
    number = gets.chomp.to_s
      if Train.find_train(number)
        puts 'Поезд найден:'
        Train.about_train(number)
      else
        puts 'Поезда с таким номером (названием) не найдено.'
      end
  end

  def take_some_space_in_wagon
    show_all_trains
    train = train_choice
    wagon = wagon_choice(train)
    if wagon.is_a?( CargoWagon )
      print 'Какой объем планируете занять, ед. : '
      volume = gets.chomp.to_i
      wagon.take_some_volume(volume)
    else
      wagon.take_a_seat
    end
  end

  def wagon_choice(train)
    print "Введите номер вагона (всего #{train.wagons.size}): "
    number = gets.chomp.to_i
    wagon = train.wagons[number - 1]
  end

  def show_wagons_of_train
    if @all_trains.size > 0
      show_all_trains
      train = train_choice

      if train.is_a?( CargoTrain )
        train.each_wagon_in_train { |wagon, index|
        puts "#{index}  |  #{wagon.class}  |  свободного объема, ед.: #{wagon.free_volume}  |  зянятый объем, ед.: #{wagon.occupied_volume}" }
      else
        train.each_wagon_in_train { |wagon, index|
        puts "#{index}  |  #{wagon.class}  |  свободных мест: #{wagon.free_seats}  |  занято: #{wagon.occupied_seats}" }
      end
    else
      puts 'Нет ни одного поезда!'
    end

  end

end
