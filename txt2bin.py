def hex_to_binary(file_path, output_path):
    # 初始化一个空的字节数组用于存储二进制数据
    binary_data = bytearray()

    # 打开文件并读取每一行
    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            # 分割每一行中的十六进制数
            hex_values = line.strip().split()
            # 遍历十六进制数并转换为二进制
            for hex_value in hex_values:
                if hex_value == '--':   
                    continue;
                # 转换十六进制到整数，然后到字节
                binary_data.append(int(hex_value, 16))

    # 将二进制数据写入输出文件
    with open(output_path, 'wb') as output_file:
        output_file.write(binary_data)

# 调用函数
file_path = r'1.txt'  # 替换为你的十六进制文件路径
output_path = r'1'  # 替换为你想要保存的二进制文件路径
hex_to_binary(file_path, output_path)
