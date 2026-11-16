enum NivelPrecisao { alta, media, baixa }

/// Classifica a precisão do GPS em metros.
/// Alta: < 15 m | Média: 15 a 50 m | Baixa: > 50 m
NivelPrecisao classificarPrecisao(double precisaoEmMetros) {
  if (precisaoEmMetros < 15) return NivelPrecisao.alta;
  if (precisaoEmMetros <= 50) return NivelPrecisao.media;
  return NivelPrecisao.baixa;
}

String rotuloPrecisao(NivelPrecisao nivel) {
  switch (nivel) {
    case NivelPrecisao.alta:
      return 'Alta precisão';
    case NivelPrecisao.media:
      return 'Precisão média';
    case NivelPrecisao.baixa:
      return 'Baixa precisão';
  }
}
