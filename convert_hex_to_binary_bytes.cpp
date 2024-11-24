#include <iostream>
#include <string>
#include <vector>
#include <cmath> // for std::pow
#include <algorithm> // for std::remove



#include <fstream>
#include <sstream>
#include <iomanip> // 用于std::hex和std::setw


// Function to convert a single hex character to its 4-bit binary representation
std::string hexCharToBinary(char hexChar) {
    int decimalValue = 0;
    if (hexChar >= '0' && hexChar <= '9') {
        decimalValue = hexChar - '0';
    } else if (hexChar >= 'A' && hexChar <= 'F') {
        decimalValue = 10 + (hexChar - 'A');
    } else if (hexChar >= 'a' && hexChar <= 'f') {
        decimalValue = 10 + (hexChar - 'a');
    } else {
        throw std::invalid_argument("Invalid hex character");
    }

    // Convert the decimal value to a 4-bit binary string
    std::string binary(4, '0'); // Initialize with 4 zeros
    for (int i = 3; i >= 0; --i) {
        binary[i] = (decimalValue & (1 << i)) ? '1' : '0';
    }
    return binary;
}

// Function to convert a hex string to a vector of bytes (binary data)
std::vector<unsigned char> hexToBinaryData(const char *hexStr, int len) {
    std::vector<unsigned char> binaryData;
    std::string binaryStr;

    // Convert each hex character to 4-bit binary and concatenate
    for (size_t i = 0; i < len; i++) {
        std::string binaryPart = hexCharToBinary(hexStr[i]);
        binaryStr += binaryPart;
    }

    // Convert the binary string to bytes
    for (size_t i = 0; i < binaryStr.size(); i += 8) {
        unsigned char byte = 0;
        for (int j = 0; j < 8; ++j) {
            byte |= (binaryStr[i + j] == '1') << (7 - j);
        }
        binaryData.push_back(byte);
    }

    return binaryData;
}



// 函数：将字节转换为16进制字符串
std::string byteToHex(unsigned char byte) {
    std::stringstream ss;
    ss << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(byte);
    return ss.str();
}

// 函数：读取文件的二进制数据并转换为16进制字符串
std::string fileToHex(const std::string& filename) {
    std::ifstream file(filename, std::ios::binary); // 以二进制模式打开文件
    if (!file) {
        throw std::runtime_error("Cannot open file.");
    }

    // 获取文件大小
    std::streampos fileSize = 0;
    file.seekg(0, std::ios::end);
    fileSize = file.tellg();
    file.seekg(0, std::ios::beg);

    // 读取文件内容到vector中
    std::vector<unsigned char> buffer(fileSize);
    if (file.read(reinterpret_cast<char*>(&buffer[0]), fileSize)) {
        // 将每个字节转换为16进制字符串
        std::string hexString;
        for (size_t i = 0; i < buffer.size(); ++i) {
            hexString += byteToHex(buffer[i]);
            if (i < buffer.size() - 1) {
                hexString += " "; // 在字节之间添加空格以提高可读性
            }
        }
        return hexString;
    } else {
        throw std::runtime_error("Error reading file.");
    }
}

int main() {
    std::string filename = "1.png"; // 要读取的文件名
    std::string hexString = "";
    try {
        hexString = fileToHex(filename);
        // std::cout << "Hex representation:\n" << hexString << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }

    std::string result = "";  // 用于存储去除空格后的结果

    // 遍历输入字符串，去除空格
    for (int i = 0; i < hexString.length(); ++i) {
        if (hexString[i] != ' ') {
            result += hexString[i];  // 将非空格字符添加到结果中
        }
     }

    // 输出结果
    // std::cout << "String without spaces: " << result << std::endl;

    std::string hexData = "1A3F"; // Example hex data
    
    std::vector<unsigned char> binaryData = hexToBinaryData(result.c_str(), result.size());

    // Print the binary data as bytes
    std::cout << "Binary data as int bytes: ";
    for (size_t i = 0; i < binaryData.size(); i++) {
        std::cout << std::hex <<std::setw(2) << std::setfill('0') << static_cast<int>(binaryData[i]) << " ";
        if (i%15==0)
        {
            std::cout << std::endl;
        }
    }
    std::cout << std::endl;

     // Print the binary data as characters
    std::cout << "Binary data as characters: ";
    for (size_t i = 0; i < binaryData.size(); i++) {
        // Print the character representation of each byte
        std::cout << static_cast<char>(binaryData[i]);
        if (i%15==0)
        {
            std::cout << std::endl;
        }
    }
    std::cout << std::endl;
    return 0;
}