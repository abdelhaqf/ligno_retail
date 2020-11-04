<template>
  <!-- container all -->
  <div class="container_1 row q-pt-md">
    <!-- container left -->
    <div class="container_1_1 col-7 q-pr-md">
      <q-card flat bordered class="">
        <q-card-section class="row">
          <div class="col-4">
            <q-select
              outlined
              stack-label
              dense
              v-model="select_period"
              label="PERIODE"
              :options="list_period"
              @input="refreshTable"
            />
          </div>
        </q-card-section>
        <!-- <q-card-section> -->
        <q-markup-table flat bordered>
          <thead class="bg-blue-2">
            <tr>
              <th class="text-left">Tanggal</th>
              <th class="text-left">Distributor</th>
              <th class="text-right">Nilai</th>
              <th class="text-left">Diambil</th>
            </tr>
          </thead>
          <tbody class="bg-blue-1">
            <tr v-for="(tr, i) in list_transaction" :key="'tr' + i">
              <td class="text-left">{{ tr.date | moment("DD-MMM-YYYY") }}</td>
              <td class="text-left text-capitalize">{{ tr.distributor_name }}</td>
              <td class="text-right">{{ toCurrency(tr.total_price) }}</td>
              <td class="text-left">
                <q-toggle v-model="tr.taken" :false-value="0" :true-value="1" @input="toggleTaken(tr)" />
              </td>
            </tr>
          </tbody>
        </q-markup-table>
        <!-- </q-card-section> -->
        <q-card-section></q-card-section>
      </q-card>
    </div>
    <!-- container right -->
    <div class="container_1_2 col-5">
      <q-card flat bordered> </q-card>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      select_period: "",
      list_period: ["Agustus 2020", "September 2020"],
      list_transaction: [],
      month_name: [
        "",
        "january",
        "february",
        "march",
        "april",
        "may",
        "june",
        "july",
        "august",
        "september",
        "october",
        "november",
        "december",
      ],
    };
  },
  mounted() {
    this.$http.get("/period_list").then((result) => {
      this.list_period = result.data;
      this.list_period.forEach((x) => {
        let monthYear = (x.month = this.month_name.indexOf(x.label.split(" ")[0].toLowerCase()));
        x.year = x.label.split(" ")[1];
        x.value = x.month + " " + x.year;
      });
    });
    this.select_period = {
      label: this.$moment().format("MMMM YYYY"),
      value: this.$moment().format("M YYYY"),
      month: this.$moment().format("M"),
      year: this.$moment().format("YYYY"),
      }
    this.refreshTable();
  },
  methods: {
    toCurrency(x) {
      return this.$options.filters.currency(x, "Rp", 0, { thousandsSeparator: ".", spaceBetweenAmountAndSymbol: true });
    },
    toggleTaken(transaction) {
      // console.log(transaction)
      this.$http.post("/taken", transaction).then((result) => {});
    },
    refreshTable() {
      console.log(this.select_period);
      this.$http
        .get("/transaction/pengambilan/" + this.select_period.month + "/" + this.select_period.year)
        .then((result) => {
          this.list_transaction = result.data;
          this.list_transaction.forEach((x) => {
            x.taken = parseInt(x.taken);
          });
        });
    },
  },
};
</script>

<style lang="scss" scoped></style>
