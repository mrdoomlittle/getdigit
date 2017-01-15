# ifndef __getdigit__hpp
# define __getdigit__hpp
# include <boost/cstdint.hpp>
# include <intlen.hpp>
# include <cmath>
namespace mdl
{
    # ifdef ARC64
        typedef boost::uint64_t uint_t;
    # elif ARC32
        typedef boost::uint32_t uint_t;
    # else
        typedef unsigned int uint_t;
    # endif
    boost::uint8_t getdigit(uint_t __uint, std::size_t __unit);  
}

# endif /*__getdigit__hpp*/
