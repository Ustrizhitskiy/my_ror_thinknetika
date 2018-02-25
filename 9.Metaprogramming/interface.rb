class Interface
  include Validation

  attr_reader :all_stations, :all_trains, :all_routes, :cargo_trains,
              :passenger_trains, :count, :selected_route, :get_route_number,
              :a, :menu

  def initialize
    @all_stations = []
    @all_trains = []
    @cargo_trains = []
    @passenger_trains = []
    @all_routes = []
  end

  def menu_first
    print %(\n\n\n\n\n1.  Создать станцию.
          \r2.  Создать поезд.\n3.  Создать маршрут.
          \r4.  Добавить станцию в маршрут.\n5.  Удалить станцию из маршрута.
          \r6.  Назначить маршрут поезду.\n7.  Добавить вагон к поезду.
          \r8.  Отцепить вагон от поезда.
          \r9.  Отправить поезд на следующую по маршруту станцию.
          \r10. Отправить поезд на предыдущую по маршруту станцию.
          \r11. Просмотреть список станций.
          \r12  Просмотреть все созданные поезда.\n)
    menu_second
  end

  def menu_second
    print %(13. Просмотреть список поездов, находящихся на станции.
          \r14. Найти поезд по номеру (названию).
          \r15. Просмотреть все маршруты.
          \r16. Просмотреть состояние всех вагонов в поезде.
          \r17. Занять место (объем) в вагоне.
          \rНажмите Ctrl+C для выхода из программы.\n
          \rДля выбора действия, введите его номер: )
  end

  def menu_case
    @menu = { 1 => :create_new_station,          2 => :create_new_train,
              3 => :create_new_route,            4 => :add_station_to_route,
              5 => :delete_station_from_route,   6 => :add_route_to_train,
              7 => :add_wagon_to_train,          8 => :delete_wagon_from_train,
              9 => :move_next_station,           10 => :move_previos_station,
              11 => :all_stations_list,          12 => :show_all_trains,
              13 => :show_all_trains_on_station, 14 => :finding_train,
              15 => :show_all_routes,            16 => :show_wagons_of_train,
              17 => :take_some_space_in_wagon }
  end

  def choose
    menu_first
    number = gets.chomp.to_i
    if (1..17).cover? number
      menu_case
      send menu_case[number]
    else
      puts 'Ошибка ввода! Попробуйте еще раз.'
    end
    return_to_menu if number != 2
    choose
  end

  def return_to_menu
    puts 'Для возврата в меню нажмите ENTER'
    gets
  end

  def create_new_station
    puts 'Введите название станции:'
    name = gets.chomp.to_s
    @all_stations << Station.new(name)
    puts "Вы создали станцию #{name}"
  end

  def create_new_train
    menu_create_new_train
    type_wagon = gets.chomp.to_i
    create_cargo_train if type_wagon == 1
    create_passenger_train if type_wagon == 2
  rescue RuntimeError => e
    puts e.message
    puts "Попробуйте еще раз.\n"
    retry
  end

  def menu_create_new_train
    puts 'Какой поезд (пассажирский или грузовой) хотите создать?'
    puts '1. Грузовой.'
    puts '2. Пассажирский.'
    puts 'Введите любой другой символ и нажмите ENTER для возврата в меню...'
  end

  def create_cargo_train
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
  end

  def create_passenger_train
    print 'Введите номер или название поезда в формате ххх-хх или ххххх: '
    number = gets.chomp.to_s
    print 'Введите производителя: '
    manufacturer = gets.chomp.to_s
    train = PassengerTrain.new(number, manufacturer)
    @passenger_trains << train
    @all_trains << train
    puts "\nВы создали поезд:\nНомер: #{number}\nПроизводитель: #{manufacturer}
    \rТип: пассажирский\n"
    add_train_to_station?(train)
  end

  def add_train_to_station?(train)
    print "Добавить поезд на станцию ('Y'/'N')? "
    yes_no = gets.chomp.to_s
    if %w[y Y].include?(yes_no)
      choose_station_to_add_train(train)
    else
      puts 'Позже это все равно надо будет сделать.'
      gets
    end
  end

  def choose_station_to_add_train(train)
    show_all_stations
    print 'На какую станцию добавить поезд (выберете номер из списка)? '
    number = gets.to_i
    @all_stations.each.with_index(1) do |station, index|
      station.parking_trains(train) if number == index
    end
    print "\nВы добавили поезд №_#{train.number} на станцию "
    print "#{@all_stations[number - 1].name}.\n"
  end

  def create_new_route
    if create_possible?
      create_new_route!
    else
      puts 'Для создания маршрута необхобимо минимум две станции. Создайте их.'
    end
  end

  def create_possible?
    @all_stations.size >= 2
  end

  def choose_route_number
    print 'Введите номер маршрута: '
    gets.chomp.to_i
  end

  def choose_route_start
    puts 'Выберете начальную станцию (введите номер) из имеющихся:'
    show_all_stations
    start_input = gets.to_i
    start_station = ''
    @all_stations.each.with_index(1) do |station, index|
      start_station = station if start_input == index
    end
    start_station
  end

  def choose_route_finish(av_station)
    puts 'Выберете конечную станцию (введите номер) из предложенных:'
    av_station.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
    finish_input = gets.chomp.to_i
    finish_station = ''
    av_station.each.with_index(1) do |station, index|
      finish_station = station if finish_input == index
    end
    finish_station
  end

  def create_new_route!
    number = choose_route_number
    start_station = choose_route_start
    stations_without_start_stations =
      @all_stations.reject { |station| station == start_station }
    finish_station = choose_route_finish(stations_without_start_stations)
    route = Route.new(number, start_station, finish_station)
    puts %(Вы создали маршрут:\nНомер маршрута: #{number}
    \rНачальная станция: #{start_station.name}
    \rКонечная станция: #{finish_station.name})
    @all_routes << route
  end

  def add_station_to_route
    @a = - 1
    show_all_routes
    print 'Введите номер маршрута, в который хотите добавить станцию: '
    add_station_to_route! if there_route? != -1
  end

  def there_route?
    @get_route_number = gets.chomp.to_i
    @all_routes.each.with_index do |route, index|
      if route.route_number == @get_route_number
        @count = index
        @a = index
        @selected_route = route
      end
    end
    puts 'Такого маршрута не существует. Попробуйте создать.' if @a == -1
    @a
  end

  def arr_available_station
    available_stations = []
    @all_stations.each do |station|
      unless @selected_route.route_stations.include?(station)
        available_stations << station
      end
    end
    available_stations
  end

  def available_stations_empty?(available_stations)
    if available_stations.empty?
      puts 'Все существующие станции уже добавлены. Создайте новую станцию.'
      return_to_menu
      choose
    end
    puts 'На какое по порядку место хотите добавить станцию? '
    gets.chomp.to_i
  end

  def show_available_station(available_stations)
    available_stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def add_station_to_route!
    @all_routes.delete_at(@count)
    available_stations = arr_available_station
    number = available_stations_empty?(available_stations)
    show_available_station(available_stations)
    print 'Какую станцию хотите добавить (введите номер) из имеющихся: '
    station = available_stations[gets.to_i - 1]
    @selected_route.route_stations.insert(number - 1, station)
    @all_routes.insert(@count, @selected_route)
    edited_route
  end

  def edited_route
    puts "Вы изменили маршрут №_#{@get_route_number}."
    @selected_route.all_stations_of_route
  end

  def delete_station_from_route
    show_all_routes
    print 'Введите номер маршрута, из которого хотите удалить станцию: '
    delete_station_from_route! if there_route? != -1
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
    return unless there_route? != -1
    puts
    show_all_trains
    train = train_choice
    train.appoint_route(@selected_route)
  end

  def create_cargo_wagon(train)
    print 'Введите производителя вагона: '
    manufacturer = gets.to_s
    print 'Введите объем вагона: '
    total_volume = gets.to_i
    wagon = CargoWagon.new(manufacturer, total_volume)
    train.add_wagon(wagon)
    train
  end

  def create_passenger_wagon(train)
    print 'Введите производителя вагона: '
    manufacturer = gets.to_s
    print 'Введите количество мест в вагоне: '
    all_seats = gets.to_i
    wagon = PassengerWagon.new(manufacturer, all_seats)
    train.add_wagon(wagon)
    train
  end

  def add_wagon_to_train
    show_all_trains
    train = train_choice
    if train.class == CargoTrain
      create_cargo_wagon(train)
    else
      create_passenger_wagon(train)
    end
    print "\nВы добавили вагон."
    puts "Номер поезда: #{train.number},\n
      \rвагонов: #{train.wagons.size},\nтип - #{train.class}"
  end

  def delete_wagon_from_train
    show_all_trains
    train = train_choice
    train.delete_wagon
    print "\nВы удалали вагон."
    puts "Номер поезда: #{train.number},\n
      \rвагонов: #{train.wagons.size}, тип - #{train.class}"
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

  def all_stations_list
    puts 'Список всех созданных станций:'
    show_all_stations
  end

  def show_all_routes
    @all_routes.each(&:all_stations_of_route)
  end

  def show_all_trains
    @all_trains.each.with_index(1) do |train, index|
      print "#{index} | Номер (название): #{train.number}; "
      print "вагонов: #{train.wagons.size}; тип - #{train.class}\n"
    end
  end

  def choose_station_for_show
    show_all_stations
    print 'Введите станцию (выберете номер из списка): '
    gets.to_i
  end

  def show_all_trains_on_station
    number = choose_station_for_show
    if !@all_stations.empty?
      station = @all_stations[number - 1]
      station.each_train_on_station do |train, index|
        print "#{index}  |  Номер (название): #{train.number}; "
        print "тип: #{train.class}; вагонов: #{train.wagons.size}\n"
      end
    else
      puts 'Не создано ни одной станции!'
    end
  end

  def train_choice
    print 'Выберите поезд (введите порядковый номер) из списка: '
    number = gets.chomp.to_i
    @all_trains[number - 1]
  end

  def finding_train
    puts 'Введите номер (название) поезда, чтобы получить информацию о нем: '
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
    if wagon.is_a?(CargoWagon)
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
    train.wagons[number - 1]
  end

  def show_cargo_wagons(train)
    train.each_wagon_in_train do |wagon, index|
      print "#{index}  |  #{wagon.class}  |  "
      print "свободного объема, ед.: #{wagon.free_capacity}  |  "
      print "зянятый объем, ед.: #{wagon.occupied_capacity}\n"
    end
  end

  def show_passenger_wagons(train)
    train.each_wagon_in_train do |wagon, index|
      print "#{index}  |  #{wagon.class}  |  "
      print "свободных мест: #{wagon.free_capacity}  |  "
      print "занято: #{wagon.occupied_capacity}\n"
    end
  end

  def show_wagons_of_train
    if @all_trains.empty?
      puts 'Нет ни одного поезда!'
      choose
    end
    show_all_trains
    train = train_choice
    show_cargo_wagons(train) if train.is_a?(CargoTrain)
    show_passenger_wagons(train) if train.is_a?(PassengerTrain)
  end
end
