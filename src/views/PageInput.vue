<template>
  <!-- container all -->
  <div class="container_1 row q-pt-md">
    <!-- container left -->
    <div class="container_1_1 col-7 q-pr-md">
      <q-card flat bordered class="">
        <!-- form distributor -->
        <q-card-section class="row">
          <div class="col-6 ">
            <q-select
              outlined
              stack-label
              class="text-capitalize"
              v-model="transaction.distributor"
              use-input
              hide-selected
              fill-input
              input-debounce="0"
              @filter="filterFn"
              label="DISTRIBUTOR"
              :options="option_distributor_filtered"
              @input="resetData"
            />
          </div>
          <div v-if="transaction.distributor != null" class="col-6 q-pl-md">
            <q-field stack-label outlined readonly label="ONGKOS KIRIM per LITER">
              <template v-slot:control>
                <div class="self-center full-width no-outline" tabindex="0">
                  {{ toCurrency(transaction.distributor.shipping) }}
                </div>
              </template>
            </q-field>
          </div>
        </q-card-section>
      </q-card>
      <q-card flat bordered class="q-mt-md">
        <!-- item tabs -->
        <q-tabs
          dense
          v-model="tab_product_type"
          class="text-grey-6 col-12 bg-blue-2"
          align="left"
          active-color="primary"
          indicator-color="primary"
        >
          <q-tab v-for="(prod, i) in list_product" :key="'prod_tab' + i" :name="prod.type" :label="prod.type_label" />
        </q-tabs>

        <q-separator />
        <q-card-section>
          <!-- tab panels -->
          <q-tab-panels animated class="col-12" v-model="tab_product_type">
            <q-tab-panel
              class="row q-gutter-md"
              v-for="(prod, i) in list_product"
              :key="'prod_panel' + i"
              :name="prod.type"
            >
              <q-card
                flat
                bordered
                class="card-product"
                v-for="(item, j) in prod.items"
                :key="'prod_item' + i + '' + j"
                :class="{ 'bg-blue-1': item.select }"
                @click="selectProduct(item)"
              >
                <q-card-section class="text-center">
                  <div class="text-caption text-grey">
                    {{ item.name }}
                  </div>
                  <div class="text-h5">{{ toAccounting(item.netto) }} ml</div>
                  <div class="text-caption text-grey">
                    {{ toCurrency(item.base_price) }}
                  </div>
                </q-card-section>
              </q-card>
            </q-tab-panel>
          </q-tab-panels>
        </q-card-section>
        <q-inner-loading :showing="transaction.distributor == null">
          <q-spinner-puff size="50px" color="primary" />
        </q-inner-loading>
      </q-card>
    </div>
    <!-- container right -->
    <div class="container_1_2 col-5">
      <q-card flat bordered>
        <!-- receipt header -->
        <q-card-section class="row justify-between">
          <div v-if="transaction.distributor">
            {{ transaction.distributor.name | capitalize }} - {{ transaction.distributor.city | capitalize }}
          </div>
          <q-skeleton v-else width="150px"></q-skeleton>
          <div>
            <q-input dense outlined v-model="transaction.date" mask="date" :rules="['date']">
              <template v-slot:append>
                <q-icon name="event" class="cursor-pointer">
                  <q-popup-proxy ref="qDateProxy" transition-show="scale" transition-hide="scale">
                    <q-date minimal v-model="transaction.date">
                      <div class="row items-center justify-end">
                        <q-btn v-close-popup label="Close" color="primary" flat />
                      </div>
                    </q-date>
                  </q-popup-proxy>
                </q-icon>
              </template>
            </q-input>
          </div>
        </q-card-section>
        <q-separator></q-separator>

        <q-card-section>
          <!-- item on cart -->
          <q-list v-if="transaction.cart.length" separator>
            <q-item class="row" v-for="(prod, i) in transaction.cart" :key="'cart' + i">
              <q-item-section avatar class="col-4">
                <q-item-label>{{ prod.product }}</q-item-label>
                <q-item-label caption> {{ toAccounting(prod.netto) }} ml </q-item-label>
              </q-item-section>
              <q-item-section class="col-3">
                <q-input dense filled v-model="prod.final_price" type="number" prefix="Rp" />
              </q-item-section>
              <q-item-section class="col-2">
                <q-item-label>
                  <q-input dense filled v-model="prod.qty" type="number">
                    <template v-slot:before>x</template>
                  </q-input>
                </q-item-label>
              </q-item-section>
              <q-item-section side class="col-3">
                <q-item-label>{{ toCurrency(prod.qty * prod.final_price) }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
          <q-list v-else>
            <q-item class="text-caption text-grey">Pilih barang dari panel sebelah kiri</q-item>
          </q-list>
        </q-card-section>
        <q-separator />
        <!-- receipt additional info -->
        <q-card-section class="row justify-between">
          <div>
            <q-toggle v-model="transaction.taken" label="sudah diambil" :false-value="0" :true-value="1" />
          </div>
          <div class="row items-center">
            <div class="text-caption">total:</div>
            <div class="text-h6 q-pl-sm">
              {{ toCurrency(totalTransaction) }}
            </div>
          </div>
        </q-card-section>
        <q-card-section>
          <q-input stack-label outlined v-model="transaction.note" class="q-mb-md" label="catatan" type="textarea">
          </q-input>
        </q-card-section>
        <q-card-actions>
          <q-btn stretch flat class="full-width" label="SIMPAN TRANSAKSI" color="primary" @click="clickTransaction"></q-btn>
        </q-card-actions>
        <q-inner-loading :showing="transaction.distributor == null">
          <q-spinner-puff size="50px" color="primary" />
        </q-inner-loading>
      </q-card>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      option_distributor: [],
      option_distributor_filtered: [],
      tab_product_type: "dish_soap",
      list_product: [
        {
          type: "dish_soap",
          type_label: "Dish Soap",
          items: [
            {
              product: "LIGNO Dish Soap",
              netto: 450,
              base_price: 9000,
              select: false,
            },
            {
              product: "LIGNO Dish Soap",
              netto: 5000,
              base_price: 50000,
              select: false,
            },
            {
              product: "LIGNO Dish Soap",
              netto: 20000,
              base_price: 180000,
              select: false,
            },
          ],
        },
        {
          type: "hand_soap",
          type_label: "Hand Soap",
          items: [
            {
              product: "LIGNO Hand Soap",
              netto: 500,
              base_price: 20000,
              select: false,
            },
            {
              product: "LIGNO Hand Soap",
              netto: 5000,
              base_price: 100000,
              select: false,
            },
            {
              product: "LIGNO Hand Soap",
              netto: 20000,
              base_price: 400000,
              select: false,
            },
          ],
        },
        {
          type: "other",
          type_label: "Other",
          items: [
            {
              product: "LIGNO Hand Sanitizer",
              netto: 1000,
              base_price: 75000,
              select: false,
            },
            {
              product: "LIGNO Disinfectant",
              netto: 1000,
              base_price: 30000,
              select: false,
            },
            {
              product: "LIGNO Disinfectant",
              netto: 5000,
              base_price: 125000,
              select: false,
            },
          ],
        },
      ],
      transaction: {
        date: this.$moment().format("YYYY/MM/DD"),
        distributor: null,
        cart: [],
        taken: 0,
        total_price: 0,
        note: "",
      },
      cart_product: [],
    };
  },
  mounted() {
    this.$http.get("/distributor").then((result) => {
      this.option_distributor = result.data;
    });
  },
  methods: {
    toAccounting(x) {
      return this.$options.filters.number(x, "0,0", { thousandsSeparator: "." });
    },
    toCurrency(x) {
      return this.$options.filters.currency(x, "Rp", 0, { thousandsSeparator: ".", spaceBetweenAmountAndSymbol: true });
    },
    selectProduct(item) {
      item.select = !item.select;
      if (item.select) {
        let obj = Object.assign({}, item);
        obj.qty = 1;
        obj.shipping = this.transaction.distributor.shipping;
        obj.final_price = (parseInt(obj.shipping) * obj.netto) / 1000 + obj.base_price;

        this.transaction.cart.push(obj);
      } else {
        this.transaction.cart = this.transaction.cart.filter((x) => {
          return !(x.name == item.name && x.netto == item.netto);
        });
      }
    },
    resetData() {
      this.transaction.cart = [];
      this.transaction.taken = 0;
      this.transaction.total_price = 0;
      this.transaction.note = "";
      this.list_product.forEach((x) => {
        x.items.forEach((y) => {
          y.select = false;
        });
      });
    },
    clickTransaction() {
      this.transaction.total_price = this.totalTransaction;
      console.log(this.transaction);
      this.$http.post("/transaction", this.transaction).then((result) => {
        this.data = result.data;
        this.transaction.distributor = null;
        this.resetData();
      });
    },
    filterFn(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.option_distributor_filtered = this.option_distributor.filter((v) => v.name.toLowerCase().indexOf(needle) > -1);
      });
    },
  },
  computed: {
    totalTransaction() {
      let sum = 0;
      this.transaction.cart.forEach((x) => {
        sum += x.qty * x.final_price;
      });
      return sum;
    },
  },
};
</script>

<style lang="scss" scoped>
.is_selected_product {
  // background-color: azure;
}
.card-product {
  cursor: pointer;
  user-select: none;
}
</style>
