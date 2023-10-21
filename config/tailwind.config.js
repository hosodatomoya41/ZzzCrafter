module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  plugins: [require("daisyui")],
  theme: {
    extend: {
      margin: {
        '20': '5rem',
        '30': '7.5rem',
        '40': '9rem',
        '50': '11.5rem',
      },
      spacing: {
        '15': '3.75rem',
      },
      width: {
        '128': '32rem',
        '144': '36rem',
      },
      height: {
        '128': '32rem',
        '144': '36rem',
      },
      backgroundImage: {
        'nightsky': "url('/assets/beautiful_nightsky.png')",
      },
  },
  }
};

