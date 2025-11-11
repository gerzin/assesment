#include <argparse/argparse.hpp>
#include <iostream>

int main(int argc, char *argv[])
{
    argparse::ArgumentParser program("test_argparse");

    program.add_argument("command").help("command to process");

    program.add_argument("--verbose", "-v").help("enable verbose output").default_value(false).implicit_value(true);

    try
    {
        program.parse_args(argc, argv);
    }
    catch (const std::exception &err)
    {
        std::cerr << err.what() << std::endl;
        std::cerr << program;
        return 1;
    }

    auto command = program.get<std::string>("command");
    bool verbose = program.get<bool>("--verbose");

    std::cout << "Command: " << command << std::endl;
    if (verbose)
    {
        std::cout << "Verbose mode enabled" << std::endl;
    }

    return 0;
}
