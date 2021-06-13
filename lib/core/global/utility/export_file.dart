//Save data to a file.
import 'dart:collection';

import 'dart:io';

void exportToFile(var data, String filename) =>
    new _Export(data).toFile(filename);

class _Export {
  HashMap mapData;
  List listData;
  bool isMap = false;
  bool isComplex = false;

  _Export(var data) {
    // Check is input is List of Map data structure.
    if (data.runtimeType == HashMap) {
      isMap = true;
      mapData = data;
    } else if (data.runtimeType == List) {
      listData = data;
     
    } else {
      throw new ArgumentError("input data is not valid.");
    }
  }

  // Save to a file using an IOSink.  Handles Map, List and List<Complex>.
  void toFile(String filename) {
    List<String> tokens = filename.split(new RegExp(r'\.(?=[^.]+$)'));
    if (tokens.length == 1) tokens.add('txt');
    if (isMap) {
      mapData.forEach((k, v) {
        File fileHandle = new File('${tokens[0]}_k$k.${tokens[1]}');
        IOSink dataFile = fileHandle.openWrite();
        for (var i = 0; i < mapData[k].length; i++) {
          dataFile.write('${mapData[k][i].real}\t'
              '${mapData[k][i].imag}\n');
        }
        dataFile.close();
      });
    } else {
      File fileHandle = new File('${tokens[0]}_data.${tokens[1]}');
      IOSink dataFile = fileHandle.openWrite();
      if (isComplex) {
        for (var i = 0; i < listData.length; i++) {
          listData[i] = listData[i].cround2;
          dataFile.write("${listData[i].real}\t${listData[i].imag}\n");
        }
      } else {
        for (var i = 0; i < listData.length; i++) {
          dataFile.write('${listData[i]}\n');
        }
      }
      dataFile.close();
    }
  }
}
