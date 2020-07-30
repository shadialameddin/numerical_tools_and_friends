#include <iostream>
#include <fmt/core.h>
#include <variant>

class human_being // private members by default
{
public:
    std::string first_name{"unknown0"};
    std::string second_name{"unknown1"};
};

struct human_being_struct // public members by default
{
    std::string first_name{"unknown0"};
    std::string second_name{"unknown1"};
};

enum class house_colour { red, yello, green };

int main()
{
    std::cout << "Hello, World! 3" << std::endl;

    human_being x;
    fmt::print("1st name: {}\n", x.first_name);
    fmt::print("2nd name: {}\n", x.second_name);

    human_being_struct y;
    fmt::print("1st name: {}\n", y.first_name);
    fmt::print("2nd name: {}\n", y.second_name);

    house_colour col = house_colour::red;
    fmt::print("colour: {}\n", col);
    fmt::print("colour: {}\n", col == house_colour::yello);

    std::variant<std::string, double> z;
    fmt::print("variant: {}\n", typeid(z).name());
    z = 3.3;
    fmt::print("variant: {}\n", z.index());
    z = "blabla";
    fmt::print("variant: {}\n", z.index());
}
