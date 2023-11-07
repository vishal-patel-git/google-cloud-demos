import axios, {isAxiosError} from 'axios';
import {Vendor} from './models';
import {ErrorResponse} from './errors';

interface VendorsOptions {
  baseUrl: string;
}

interface OrderByClause {
  field: 'name';
  direction: 'asc' | 'desc';
}

interface ListVendorsOptions {
  orderBy?: OrderByClause[];
}

class VendorsClient {
  constructor(private readonly options: VendorsOptions) {}

  async createVendor(name: string, address: string): Promise<Vendor> {
    try {
      const {data: vendor} = await axios.post(this.options.baseUrl, {
        name,
        address,
      });

      return vendor;
    } catch (err) {
      if (isAxiosError(err)) {
        throw new ErrorResponse(
          err.response?.data.error.code,
          err.response?.data.error.message
        );
      }
      throw err;
    }
  }

  async listVendors(options?: ListVendorsOptions): Promise<Vendor[]> {
    const params: {orderBy?: string} = {};

    if (options?.orderBy) {
      params.orderBy = options.orderBy.slice(1).reduce((acc, orderByClause) => {
        return `${acc} ${this.orderByClauseToQueryParamClause(orderByClause)}`;
      }, this.orderByClauseToQueryParamClause(options.orderBy[0]));
    }

    const {data: listVendorsResponse} = await axios.get(this.options.baseUrl, {
      params,
    });

    return listVendorsResponse;
  }

  async deleteVendorById(vendorId: string): Promise<void> {
    await axios.delete(`${this.options.baseUrl}/${vendorId}`);
  }

  private orderByClauseToQueryParamClause(
    orderByClause: OrderByClause
  ): string {
    return `${orderByClause.field} ${orderByClause.direction}`;
  }
}

export {VendorsClient};
