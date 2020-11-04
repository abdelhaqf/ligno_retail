<?php
require 'vendor/autoload.php';


function getLink()
{
  $link = mysqli_connect('localhost', 'root', '', 'ligno_retail') or die('connection failed');
  return $link;
}


Flight::route('POST /transaction', function () {
  $link = getLink();
  $item = Flight::request()->data;

  $distributor_id = $item->distributor['id'];
  $date = $item->date;
  $taken = $item->taken;
  $total_price = $item->total_price;
  $note = $item->note;

  $q = "INSERT INTO transaction(distributor_id,date,taken,total_price,note) VALUES($distributor_id,'$date',$taken,$total_price,'$note') ";
  // var_dump($q);
  $res = mysqli_query($link, $q) or die(mysqli_error($link));
  $transaction_id = mysqli_insert_id($link);

  $cart = $item->cart;
  for ($i = 0; $i < count($cart); $i++) {
    $product = $cart[$i]['product'];
    $netto = $cart[$i]['netto'];
    $base_price = $cart[$i]['base_price'];
    $shipping = $cart[$i]['shipping'];
    $qty = $cart[$i]['qty'];
    $final_price = $cart[$i]['final_price'];

    $q = "INSERT INTO transaction_detail(transaction_id,product,netto,base_price,shipping,qty,final_price) 
    VALUES($transaction_id,'$product',$netto,$base_price,$shipping,$qty,$final_price)";
    $res = mysqli_query($link, $q) or die(mysqli_error($link));
    echo mysqli_insert_id($link) . ' ';
  }
});
Flight::route('GET /distributor', function () {
  $link = getLink();

  $q = "SELECT * FROM distributor";
  $res = mysqli_query($link, $q) or die(mysqli_error($link));

  $items = array();
  while ($row = mysqli_fetch_assoc($res)) {
    $row['value'] = $row['id'];
    $row['label'] = $row['name'];
    $items[] = $row;
  }

  Flight::json($items);
});
Flight::route('GET /transaction/pengambilan/@month/@year', function ($month,$year) {
  $link = getLink();

  $q = "SELECT *,transaction.id as id,distributor.name as 'distributor_name' FROM transaction
  JOIN distributor on transaction.distributor_id=distributor.id
  WHERE YEAR(Date) = $year AND MONTH(Date) = $month";
  $res = mysqli_query($link, $q) or die(mysqli_error($link));

  $items = array();
  while ($row = mysqli_fetch_assoc($res)) {
    $items[] = $row;
  }

  Flight::json($items);
});
Flight::route('POST /taken', function () {
  $link = getLink();
  $item = Flight::request()->data;

  $id = $item->id;
  $value = $item->taken;

  $q = "UPDATE transaction SET taken=$value WHERE id=$id";
  $res = mysqli_query($link, $q) or die(mysqli_error($link));
  var_dump($q);
});
Flight::route('GET /period_list', function () {
  $link = getLink();

  $q = "SELECT DISTINCT(DATE_FORMAT(date,'%M %Y')) as 'label' FROM transaction ORDER BY DATE ";
  $res = mysqli_query($link, $q) or die(mysqli_error($link));

  $items = array();
  while ($row = mysqli_fetch_assoc($res)) {
    $items[] = $row;
  }
  Flight::json($items);
});

Flight::route('/', function () {
  echo 'hello world!';
});
Flight::route('OPTIONS *', function () {
});


Flight::start();
