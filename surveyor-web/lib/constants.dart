// String linkGraphql = "http://localhost:7070/graphql";
String linkGraphql =
    "https://server-web-dot-hei-survei-v1.et.r.appspot.com/graphql";
String prefUserId = "IdUser-X1";
// bool isModeTesting = true;
// String baseUri = 'http://localhost:5050/home';
String baseUri = 'https://hei-survei-v1.web.app';
bool isPembayaranMidtrans = true;

String keyCrypto = "RahasiaHeySurvei";

enum TipeCharts {
  pieChart,
  nomorxEmail,
  barChart,
  emailxJawaban,
  funnelChart,
  donutChart,
  pyramidChart,
  histogram
}

List<TipeCharts> listChartDataString = [
  TipeCharts.pieChart,
  TipeCharts.funnelChart,
  TipeCharts.pyramidChart,
  TipeCharts.donutChart,
];

List<TipeCharts> listChartDataAngka = [
  TipeCharts.barChart,
  TipeCharts.histogram,
];

List<TipeCharts> listChartDataTabel = [TipeCharts.emailxJawaban];

List<TipeCharts> listChartDataTabelNomor = [TipeCharts.nomorxEmail];

extension TipeChartsString on TipeCharts {
  String get value {
    switch (this) {
      case TipeCharts.pieChart:
        return "Pie Chart";
      case TipeCharts.barChart:
        return "barChart";
      case TipeCharts.emailxJawaban:
        return "email - Jawaban";
      case TipeCharts.funnelChart:
        return "Funnel Chart";
      case TipeCharts.nomorxEmail:
        return "nomor - Email";
      case TipeCharts.pyramidChart:
        return "Pyramid Chart";
      case TipeCharts.donutChart:
        return "Donut Chart";
      case TipeCharts.histogram:
        return "Histogram";
    }
  }
}
