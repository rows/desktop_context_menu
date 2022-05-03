#include <windows.h>
#include <string>

namespace Encoding {
    /**
        * @brief Converts an UTF-8 string to a wide string.
        * 
        * @param str 
        * @return std::wstring 
        */
    std::wstring Utf8ToWide(const std::string& str)
    {
        int count = MultiByteToWideChar(
            CP_UTF8, 
            0, 
            str.c_str(), 
            static_cast<int>(str.length()), 
            nullptr, 
            0);
        std::wstring wstr(count, 0);
        MultiByteToWideChar(
            CP_UTF8, 
            0, 
            str.c_str(), 
            static_cast<int>(str.length()), 
            &wstr[0], 
            count);
        return wstr;
    }
}