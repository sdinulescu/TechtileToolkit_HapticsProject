// 0 => read 0 -> 256
// 1 => read 512 -> (512 + 256)
inlets = 1;
outlets = 1;
autowatch = 1;

noteList = [(523.3/2), (659.3/2), (784.0/2), (1046.6/2)]; // C5, E5, G5, C6

function msg_float(detected) {
  
  // detected -> 640.33333333333
  // expect it to match with C5..
  diffList = [];
  diffList[0] = Math.abs(noteList[0]-detected); // --> 117
  diffList[1] = Math.abs(noteList[1]-detected);
  diffList[2] = Math.abs(noteList[2]-detected);
  diffList[3] = Math.abs(noteList[3]-detected);

  // which o
  min = Math.min.apply(Math, diffList); // min doesn't help us
  matchingIndex = diffList.indexOf(min); // could return -1

  closestNote = noteList[matchingIndex];

  outlet(0, closestNote);
}