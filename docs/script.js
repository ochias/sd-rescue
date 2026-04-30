// PayPal donate — email is base64-encoded so it isn't visible in HTML source
// to scrapers/bots. Final URL is built only on click.
(function () {
  var btn = document.getElementById('donate-btn');
  if (!btn) return;

  btn.addEventListener('click', function () {
    var b = ['b3Jpb2wuY2hpYXM=', 'ZWxvZ2lhLm5ldA=='].map(atob).join('@');
    var url = 'https://www.paypal.com/donate/?business=' +
      encodeURIComponent(b) +
      '&item_name=' + encodeURIComponent('Support sd-rescue') +
      '&currency_code=EUR';
    window.open(url, '_blank', 'noopener');
  });
})();
