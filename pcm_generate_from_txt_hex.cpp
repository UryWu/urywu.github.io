#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <string>

// 定义音频参数
const int SAMPLE_RATE = 44100; // 采样率
const int BITS_PER_SAMPLE = 8; // 位深
const int CHANNELS = 1; // 声道数（1为单声道）

// 从文件中读取十六进制字符串
std::string readHexDataFromFile(const std::string& filename) {
    std::ifstream inFile(filename);
    if (!inFile) {
        std::cerr << "无法打开文件进行读取" << std::endl;
        exit(1);
    }

    std::stringstream buffer;
    buffer << inFile.rdbuf();
    return buffer.str();
}

// 将十六进制字符串转换为PCM数据
std::vector<unsigned char> hexToPCM(const std::string& hexStr) {
    std::vector<unsigned char> pcmData;
    std::istringstream hexStream(hexStr);
    std::string hexByte;
    int validCount = 0;
    int totalCount = 0;
    while (std::getline(hexStream, hexByte, ' ')) {
        totalCount++;
        if (hexByte.length() == 2) {
            try {
                // 将十六进制字符串转换为unsigned char类型的PCM样本值
                unsigned char sample = static_cast<unsigned char>(std::stoi(hexByte, nullptr, 16));
                pcmData.push_back(sample);
                validCount++;
            } catch (const std::invalid_argument& e) {
                std::cerr << "无效的十六进制字符: " << hexByte << std::endl;
            } catch (const std::out_of_range& e) {
                std::cerr << "十六进制数值超出范围: " << hexByte << std::endl;
            }
        }
    }
    if (validCount != totalCount) {
        std::cerr << "警告: 只有 " << validCount << " 个有效的十六进制数被转换，总共 " << totalCount << " 个数。" << std::endl;
    }
    return pcmData;
}

int main() {
    system("chcp 65001");

    // 文件名
    std::string filename = "1.txt";

    // 从文件中读取十六进制数据
    std::string hexData = readHexDataFromFile(filename);

    // 将十六进制数据转换为PCM数据
    std::vector<unsigned char> pcmData = hexToPCM(hexData);

    // 打开文件
    std::ofstream outFile("pcm_generate_from_txt_hex.pcm", std::ios::binary);
    if (!outFile) {
        std::cerr << "无法打开文件进行写入" << std::endl;
        return 1;
    }

    // 写入PCM数据
    outFile.write(reinterpret_cast<const char*>(pcmData.data()), pcmData.size());

    // 关闭文件
    outFile.close();

    std::cout << "PCM音频临时文件生成完毕" << std::endl;

    // 输出音频参数
    std::cout << "音频参数：" << std::endl;
    std::cout << "采样率：" << SAMPLE_RATE << " Hz" << std::endl;
    std::cout << "位深：" << BITS_PER_SAMPLE << " bits" << std::endl;
    std::cout << "声道数：" << CHANNELS << std::endl;

    return 0;
}