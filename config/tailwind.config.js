module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  plugins: [require("daisyui")],
  theme: {
    extend: {
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
  },
  }
};

