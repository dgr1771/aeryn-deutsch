/// 数字矩阵模块 - Number Matrix
///
/// 实现"跳跃式学习"德语数字，从1到1,000,000
/// 逻辑：sechzehn = sechs + zehn (看组成规律而非死记)
class NumberMatrix {
  // 基础数字 0-20
  static const Map<int, String> basicNumbers = {
    0: 'null',
    1: 'eins',
    2: 'zwei',
    3: 'drei',
    4: 'vier',
    5: 'fünf',
    6: 'sechs',
    7: 'sieben',
    8: 'acht',
    9: 'neun',
    10: 'zehn',
    11: 'elf',
    12: 'zwölf',
    13: 'dreizehn',
    14: 'vierzehn',
    15: 'fünfzehn',
    16: 'sechzehn',
    17: 'siebzehn',
    18: 'achtzehn',
    19: 'neunzehn',
    20: 'zwanzig',
  };

  // 十位数字
  static const Map<int, String> tens = {
    20: 'zwanzig',
    30: 'dreißig',
    40: 'vierzig',
    50: 'fünfzig',
    60: 'sechzig',
    70: 'siebzig',
    80: 'achtzig',
    90: 'neunzig',
  };

  // 大数字
  static const Map<int, String> largeNumbers = {
    100: 'hundert',
    1000: 'tausend',
    1000000: 'eine Million',
  };

  /// 将数字转换为德语单词
  ///
  /// 核心算法：递归分解 + 逻辑拼装
  static String numberToGerman(int number) {
    if (number < 0) return 'minus ${numberToGerman(-number)}';
    if (number == 0) return basicNumbers[0]!;

    // 1-19：直接返回
    if (number <= 19) {
      return basicNumbers[number] ?? '';
    }

    // 20-99：个位在前，十位在后 (德语特色)
    if (number < 100) {
      final ones = number % 10;
      final tensDigit = (number ~/ 10) * 10;

      if (ones == 0) {
        return tens[tensDigit] ?? '';
      }

      // 德语规则：einundzwanzig (1 + und + 20)
      final onesWord = ones == 1 ? 'ein' : basicNumbers[ones];
      final tensWord = tens[tensDigit];
      return '${onesWord}und${tensWord}';
    }

    // 100-999
    if (number < 1000) {
      final hundreds = number ~/ 100;
      final remainder = number % 100;

      final hundredsWord = hundreds == 1
          ? 'ein${largeNumbers[100]}'
          : '${basicNumbers[hundreds]}${largeNumbers[100]}';

      if (remainder == 0) {
        return hundredsWord;
      }
      return '$hundredsWord${numberToGerman(remainder)}';
    }

    // 1000-999999
    if (number < 1000000) {
      final thousands = number ~/ 1000;
      final remainder = number % 1000;

      final thousandsWord = thousands == 1
          ? 'ein${largeNumbers[1000]}'
          : '${numberToGerman(thousands)}${largeNumbers[1000]}';

      if (remainder == 0) {
        return thousandsWord;
      }
      return '$thousandsWord${numberToGerman(remainder)}';
    }

    // 1,000,000+
    if (number == 1000000) {
      return largeNumbers[1000000]!;
    }

    return number.toString(); // 超出范围返回原数字
  }

  /// 解析数字的组成结构（用于"解剖刀"UI展示）
  ///
  /// 例如：621 = [600, 20, 1]
  /// 德语：sechshunderteinundzwanzig
  static NumberDecomposition decompose(int number) {
    final parts = <NumberPart>[];

    if (number >= 1000000) {
      final millions = number ~/ 1000000;
      parts.add(NumberPart(
        value: millions * 1000000,
        german: largeNumbers[1000000]!,
        type: NumberPartType.million,
      ));
    }

    if (number >= 1000) {
      final thousands = (number % 1000000) ~/ 1000;
      if (thousands > 0) {
        parts.add(NumberPart(
          value: thousands * 1000,
          german: thousands == 1 ? 'ein${largeNumbers[1000]}' : '${numberToGerman(thousands)}${largeNumbers[1000]}',
          type: NumberPartType.thousand,
        ));
      }
    }

    if (number >= 100) {
      final hundreds = (number % 1000) ~/ 100;
      if (hundreds > 0) {
        parts.add(NumberPart(
          value: hundreds * 100,
          german: hundreds == 1 ? 'ein${largeNumbers[100]}' : '${basicNumbers[hundreds]}${largeNumbers[100]}',
          type: NumberPartType.hundred,
        ));
      }
    }

    // 处理个位和十位
    final remainder = number % 100;
    if (remainder > 0) {
      if (remainder <= 19) {
        parts.add(NumberPart(
          value: remainder,
          german: basicNumbers[remainder]!,
          type: NumberPartType.basic,
        ));
      } else {
        final ones = remainder % 10;
        final tens = remainder ~/ 10 * 10;
        if (ones > 0) {
          parts.add(NumberPart(
            value: ones,
            german: ones == 1 ? 'ein' : (basicNumbers[ones] ?? ''),
            type: NumberPartType.ones,
          ));
          parts.add(NumberPart(
            value: 0,
            german: 'und',
            type: NumberPartType.connector,
          ));
        }
        parts.add(NumberPart(
          value: tens,
          german: NumberMatrix.tens[tens]!,
          type: NumberPartType.tens,
        ));
      }
    }

    return NumberDecomposition(
      original: number,
      german: numberToGerman(number),
      parts: parts,
    );
  }

  /// 训练模式：生成指定范围的随机数字
  static int generateRandom(int min, int max) {
    return min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));
  }

  /// 验证用户输入是否正确
  static bool validateInput(int target, String userInput) {
    final correct = numberToGerman(target);
    // 移除空格和特殊字符后比较
    final normalizedUser = userInput.toLowerCase().replaceAll(RegExp(r'[\s-]'), '');
    final normalizedCorrect = correct.toLowerCase().replaceAll(RegExp(r'[\s-]'), '');
    return normalizedUser == normalizedCorrect;
  }
}

/// 数字分解结果
class NumberDecomposition {
  final int original;
  final String german;
  final List<NumberPart> parts;

  NumberDecomposition({
    required this.original,
    required this.german,
    required this.parts,
  });
}

/// 数字组成部分
class NumberPart {
  final int value;
  final String german;
  final NumberPartType type;

  NumberPart({
    required this.value,
    required this.german,
    required this.type,
  });
}

/// 数字部分类型
enum NumberPartType {
  million,
  thousand,
  hundred,
  tens,
  ones,
  basic,
  connector, // und
}
