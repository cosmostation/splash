import { XAxisOptions, YAxisOptions } from 'highcharts';

export const xAxis: XAxisOptions = {
  visible: true,
  labels: {
    overflow: 'allow',
    align: 'center',
    staggerLines: 1,
  },
  minPadding: 0,
  maxPadding: 0,
  tickColor: 'transaprent',
  gridLineDashStyle: 'LongDash',
};

export const yAxis: YAxisOptions = {
  visible: true,
  opposite: true,
  endOnTick: true,
  labels: {
    enabled: false,
    align: 'left',
  },
  title: {
    text: '',
  },
  tickAmount: 5,
  tickPosition: 'inside',
  gridLineDashStyle: 'Dot',
};

export const defaultOptions: Highcharts.Options = {
  credits: {
    enabled: false,
  },
  title: {
    text: '',
  },
  legend: {
    enabled: false,
  },
  chart: {
    type: 'areaspline',
    margin: [20, 20, 20, 20],
    height: 45,
    width: 120,
  },
  plotOptions: {
    series: {
      states: {
        hover: {
          enabled: true,
          lineWidthPlus: 0,
          halo: {
            size: 0,
            opacity: 0,
          },
        },
        select: {
          enabled: false,
        },
      },
      allowPointSelect: false,
      marker: {
        enabled: false,
      },
    },
  },
  tooltip: {
    enabled: true,
    backgroundColor: '#ffffff',
    borderColor: '#e6e6e6',
    borderRadius: 10,
    borderWidth: 1,
    useHTML: true,
  },
  accessibility: {
    enabled: false,
  },
};

export const stakedOptions: Highcharts.Options = {
  chart: {
    type: 'column',
    height: '320px',
  },
  title: {
    text: '',
  },
  legend: {
    enabled: false,
  },
  plotOptions: {
    column: {
      stacking: 'normal',
      dataLabels: {
        enabled: false,
      },
      borderWidth: 0,
      pointWidth: 10,
    },
  },
  credits: {
    enabled: false,
  },
  tooltip: {
    enabled: true,
    borderRadius: 10,
    borderWidth: 1,
    useHTML: true,
  },
  accessibility: {
    enabled: false,
  },
};
